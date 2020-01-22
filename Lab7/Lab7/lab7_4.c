/*
 * lab7_5.c 1826
  ;Name: Nicholas Legault
  ;Class#: 12379
  ;Description: This code sends the data picked up by part 3 and outputs the raw data over to serial plot 
 */

 /*
 #include <avr/io.h>
 #include <avr/interrupt.h>
 #define PERIOD 2500
 #define BLUE_PWM_LED PIN6_bm
 int16_t data = 0; 
 int volatile data_flag = 0; 

 //Setting up the counter to trigger an overflow ever 2HZ
 void tcc0_init(void) {
	 TCC0_PERL = (uint8_t)PERIOD;
	 TCC0_PERH = (uint8_t)(PERIOD >> 8);
	 TCC0_CTRLA = 0x04;
	 //Set an event to occur when the overflow flag is set on channel 0
	 EVSYS_CH0MUX = EVSYS_CHMUX_TCC0_OVF_gc;
 }


  void adc_init() {
	  //Initialize the adc functionality to 12 bit right shifted in differential with gain setting up pin 1 and 6 on porta for mux control
	  ADCA.CTRLB = ADC_RESOLUTION_12BIT_gc | ADC_CONMODE_bm;
	  ADCA_REFCTRL = ADC_REFSEL_AREFB_gc;
	  ADCA_PRESCALER = ADC_PRESCALER_DIV512_gc;
	  PORTA_DIRCLR = PIN1_bm | PIN6_bm;
	  ADCA_CH0_CTRL = ADC_CH_INPUTMODE_DIFFWGAIN_gc;
	  ADCA_CH0_MUXCTRL = ADC_CH_MUXPOS_PIN1_gc | ADC_CH_MUXNEG_PIN6_gc;
	  ADCA_CH0_INTCTRL = ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_LO_gc;
	  //Set up the interrupt on the adc as specified
	  PMIC_CTRL = PMIC_LOLVLEN_bm;
	  sei();
	  ADCA_EVCTRL = ADC_SWEEP_0_gc | ADC_EVSEL_0123_gc | ADC_EVACT_CH0_gc;
	  ADCA_CTRLA = ADC_ENABLE_bm;
  }

 void usartd0_init(void) {
  /* configure relevant TxD and RxD pins */
/*	PORTD.OUTSET = PIN3_bm;
	PORTD.DIRSET = PIN3_bm;
	PORTD.DIRCLR = PIN2_bm;

  /* configure baud rate */
	 //At 2 MHz SYSclk, 75 BSEL, -6 BSCALE corresponds to 57600 bps */
//USARTD0.BAUDCTRLA = (uint8_t)0;
//USARTD0.BAUDCTRLB = (uint8_t)((-3 << 4) | (0 >> 8));

  /* in this example, a protocol with 8 data bits, no parity, and
   * one stop bit is chosen. */
//USARTD0.CTRLC = USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc & ~USART_SBMODE_bm;

  /* enable receiver and/or transmitter systems */
//	USARTD0.CTRLB = USART_RXEN_bm | USART_TXEN_bm;
 //}
 //When the interrupt occurs then store the data into data and toggle the blue light as well as toggle the global flag
/* ISR(ADCA_CH0_vect) {
	 data = ADCA_CH0_RES;
	 PORTD_OUTTGL = BLUE_PWM_LED;
	 data_flag = 1;
 }
 /*****************************************************************************
 * Name: usartd0_out_char
 * Purpose: To output a character from the transmitter within USARTD0.
 * Input(s): c (char)
 * Output: N/A
 ******************************************************************************/
 /*
 void usartd0_out_char(char c)
 {
	 while(!(USARTD0.STATUS & USART_DREIF_bm));
	 USARTD0.DATA = c;
 }

 int main(void)
 {
	 PORTD_OUTSET = 0x00;
	 PORTD_DIRSET = BLUE_PWM_LED;
	 //Initialize the needed functions for adc, timer, and usart 
	 adc_init();
	 tcc0_init();
	 usartd0_init();

	 
	 while (1) {
		if(data_flag) {
		//When the data is set output the raw two bytes of data into usart for the serial plot to plot 
			char c;
			data_flag = 0;
			c = ((uint8_t)data) +'0';
			usartd0_out_char(c);
			c = ((uint8_t)data>>8) +'0';
			usartd0_out_char(c);
		}
	};
	 return 0;
}
*/