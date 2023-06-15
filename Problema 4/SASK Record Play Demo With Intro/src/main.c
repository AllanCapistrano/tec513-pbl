#include <p33FJ256GP506.h>
#include "..\h\OCPWMDrv.h"
#include "..\h\sask.h"
#include "..\h\SFMDrv.h"
#include "..\h\G711.h"
#include "..\h\ADCChannelDrv.h"
#include <stdlib.h>
#include <stdio.h>

_FGS(GWRP_OFF & GCP_OFF);
_FOSCSEL(FNOSC_FRC);
_FOSC(FCKSM_CSECMD & OSCIOFNC_ON & POSCMD_NONE);
_FWDT(FWDTEN_OFF);

/* FRAME_SIZE - Size of each audio frame 	
 * SPEECH_SEGMENT_SIZE - Size of intro speech segment
 * WRITE_START_ADDRESS - Serial Flash Memory write address					
 * */

#define FRAME_SIZE 				192			
#define SPEECH_SEGMENT_SIZE		98049L		
#define WRITE_START_ADDRESS	0x20000		
#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))
#define MAX(X, Y) (((X) < (Y)) ? (Y) : (X))
#define FILTER_SIZE 37 // numero maximo de coeficientes
#define CONVOLUTION_SIZE FRAME_SIZE + FILTER_SIZE - 1


/* Allocate memory for buffers and drivers	*/

int		adcBuffer		[ADC_CHANNEL_DMA_BUFSIZE] 	__attribute__((space(dma)));
int		ocPWMBuffer		[OCPWM_DMA_BUFSIZE]		__attribute__((space(dma)));
int		samples			[FRAME_SIZE];
char 	encodedSamples	[FRAME_SIZE];
int 	decodedSamples	[FRAME_SIZE];
char 	flashMemoryBuffer	[SFMDRV_BUFFER_SIZE];

/* Instantiate the drivers 	*/
ADCChannelHandle adcChannelHandle;
OCPWMHandle 	ocPWMHandle;

/* Create the driver handles	*/
ADCChannelHandle *pADCChannelHandle 	= &adcChannelHandle;
OCPWMHandle 	*pOCPWMHandle 		= &ocPWMHandle;

/* Addresses 
 * currentReadAddress - This one tracks the intro message	
 * currentWriteAddress - This one tracks the writes to flash	
 * userPlaybackAddress - This one tracks user playback		
 * address - Used during flash erase
 * */

 long currentReadAddress;		
 long currentWriteAddress;		
 long userPlaybackAddress;
 long address;	
 
 /* flags
 * record - if set means recording
 * playback - if set mean playback
 * erasedBeforeRecord - means SFM eras complete before record
 * */	

int record;						
int playback;						
int erasedBeforeRecord;	

int main(void)
{
	/* Configure Oscillator to operate the device at 40MHz.
	 * Fosc= Fin*M/(N1*N2), Fcy=Fosc/2
	 * Fosc= 7.37M*40/(2*2)=80Mhz for 7.37M input clock */
	 
	PLLFBD=41;				/* M=39	*/
	CLKDIVbits.PLLPOST=0;		/* N1=2	*/
	CLKDIVbits.PLLPRE=0;		/* N2=2	*/
	OSCTUN=0;		
	
	__builtin_write_OSCCONH(0x01);		/*	Initiate Clock Switch to FRC with PLL*/
	__builtin_write_OSCCONL(0x01);
	while (OSCCONbits.COSC != 0b01);	/*	Wait for Clock switch to occur	*/
	while(!OSCCONbits.LOCK);

	
	/* Intialize the board and the drivers	*/
    SASKInit();
	ADCChannelInit	(pADCChannelHandle,adcBuffer);			/* For the ADC	*/
	OCPWMInit		(pOCPWMHandle,ocPWMBuffer);			/* For the OCPWM	*/

	/* Open the flash and unprotect it so that
	 * it can be written to.
	 * */

	SFMInit(flashMemoryBuffer);
	
		
	/* Start Audio input and output function	*/
	ADCChannelStart	(pADCChannelHandle);
	OCPWMStart		(pOCPWMHandle);	
		
	
	/* Main processing loop. Executed for every input and 
	 * output frame	*/
	 
    int i,j,h_start,x_start,x_end;
    
    int filt_index = 0;
    int conv[] = {FRAME_SIZE + 20 - 1, FRAME_SIZE + 21 - 1, FRAME_SIZE + 37 - 1, FRAME_SIZE + 37 - 1};
    int filter_size[] = {20, 21, 37, 37};
    float filter[4][37] ={
        {0.000519670077162788, -0.00133804485937837, -0.00575333244305388, 0.00293102228281686, 0.022656913406192, 0.00302563918179033, -0.0617822321732576, -0.0407034123243201, 0.1697475370652, 0.410696239786848, 0.410696239786848, 0.1697475370652, -0.0407034123243201, -0.0617822321732576, 0.00302563918179033, 0.022656913406192, 0.00293102228281686, -0.00575333244305388, -0.00133804485937837, 0.000519670077162788, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, // Filtro passa-baixa
        {-0.00020059189649843, -0.001415122470292, 0.00545760849238549, -0.00550952228656272, -0.00821450986813139, 0.0318301492758272, -0.0355944938978164, -0.0182944773752724, 0.133469995452106, -0.256655088874649, 0.310075859974012, -0.256655088874649, 0.133469995452106, -0.0182944773752724, -0.0355944938978164, 0.0318301492758272, -0.00821450986813139, -0.00550952228656272, 0.00545760849238549, -0.001415122470292, -0.00020059189649843, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, // Filtro passa-alta
        {-0.00190040963452221, 0.00390402787721805, 0.00587919633866434, -1.50201273640444E-17, 0.00378541379131603, 0.0197828178040134, 0.017741395894512, -0.00372744337365784, 3.47035989787178E-17, 0.0237405565602521, -6.72297156735173E-17, -0.0575202749128704, -0.0489351597315853, 1.23906991534854E-17, -0.0614955738087234, -0.189832227121894, -0.11358135514904, 0.206523331914418, 0.399110893749651, 0.206523331914418, -0.11358135514904, -0.189832227121894, -0.0614955738087234, 1.23906991534854E-17, -0.0489351597315853, -0.0575202749128704, -6.72297156735173E-17, 0.0237405565602521, 3.47035989787178E-17, -0.00372744337365784, 0.017741395894512, 0.0197828178040134, 0.00378541379131603, -1.50201273640444E-17, 0.00587919633866434, 0.00390402787721805, -0.00190040963452221}, // Filtro passa-faixa
        {-7.37135538043494E-18, 0.00518135250728207, 0.00944128440689237, 0.00765827667263328, -7.64609879104238E-18, -0.00623131293000312, -0.00409594745892862, 0.00268128631910686, -2.58321917530922E-17, -0.0211053649839184, -0.0476212654588197, -0.0478927905012957, -9.57756567114307E-17, 0.0782474342784846, 0.130841806314935, 0.104878628018674, -2.7007640699615E-17, -0.120474883227454, 0.816982992084824, -0.120474883227454, -2.7007640699615E-17, 0.104878628018674, 0.130841806314935, 0.0782474342784846, -9.57756567114307E-17, -0.0478927905012957, -0.0476212654588197, -0.0211053649839184, -2.58321917530922E-17, 0.00268128631910686, -0.00409594745892862, -0.00623131293000312, -7.64609879104238E-18, 0.00765827667263328, 0.00944128440689237, 0.00518135250728207, -7.37135538043494E-18} // Filtro rejeita-faixa
    };
    
	while(1)
	{
            /* Obtaing the ADC samples	*/
			while(ADCChannelIsBusy(pADCChannelHandle));
			ADCChannelRead	(pADCChannelHandle,samples,FRAME_SIZE);
            
            int output[conv[filt_index]];
            
            for (i = 0; i < conv[filt_index]; i++) {
                output[i] = 0;
            }
            
            for (i = 0; i < conv[filt_index]; i++) {
                x_start = MAX(0, i - FRAME_SIZE + 1); // max FILTER_SIZE
                x_end   = MIN(i + 1, filter_size[filt_index]); // max FILTER_SIZE
                h_start = MIN(i, FRAME_SIZE - 1); // max FRAME_SIZE - 1

                for(j = x_start; j < x_end; j++) //
                {
                    output[i] += (int) samples[h_start--] * filter[filt_index][j];
                }
            }
            
            /* Wait till the OC is available for a new  frame	*/
			while(OCPWMIsBusy(pOCPWMHandle));	
		
			/* Write the frame to the output	*/
            OCPWMWrite (pOCPWMHandle, output, conv[filt_index]);
					
        if((CheckSwitchS1()) == 1){
            filt_index++;
            
            switch(filt_index) {
                case 1:
                    GREEN_LED = 0;
                    YELLOW_LED = 1;
                    break;
                case 2:
                    GREEN_LED = 1;
                    YELLOW_LED = 0;
                    break;
                case 3:
                    GREEN_LED = 0;
                    YELLOW_LED = 0;
                    break;
                default:
                    GREEN_LED = 1;
                    YELLOW_LED = 1;
                    filt_index = 0;
                    break;
            }
        }
	}
}
