/* Register definitions for pic12f635.
 * This file was automatically generated by:
 *   inc2h.pl V4585
 *   Copyright (c) 2002, Kevin L. Pauba, All Rights Reserved
 */
#include <pic12f635.h>

__sfr  __at (INDF_ADDR)                    INDF;
__sfr  __at (TMR0_ADDR)                    TMR0;
__sfr  __at (PCL_ADDR)                     PCL;
__sfr  __at (STATUS_ADDR)                  STATUS;
__sfr  __at (FSR_ADDR)                     FSR;
__sfr  __at (PORTA_ADDR)                   PORTA;
__sfr  __at (GPIO_ADDR)                    GPIO;
__sfr  __at (PCLATH_ADDR)                  PCLATH;
__sfr  __at (INTCON_ADDR)                  INTCON;
__sfr  __at (PIR1_ADDR)                    PIR1;
__sfr  __at (TMR1L_ADDR)                   TMR1L;
__sfr  __at (TMR1H_ADDR)                   TMR1H;
__sfr  __at (T1CON_ADDR)                   T1CON;
__sfr  __at (WDTCON_ADDR)                  WDTCON;
__sfr  __at (CMCON0_ADDR)                  CMCON0;
__sfr  __at (CMCON1_ADDR)                  CMCON1;
__sfr  __at (OPTION_REG_ADDR)              OPTION_REG;
__sfr  __at (TRISA_ADDR)                   TRISA;
__sfr  __at (TRISIO_ADDR)                  TRISIO;
__sfr  __at (PIE1_ADDR)                    PIE1;
__sfr  __at (PCON_ADDR)                    PCON;
__sfr  __at (OSCCON_ADDR)                  OSCCON;
__sfr  __at (OSCTUNE_ADDR)                 OSCTUNE;
__sfr  __at (LVDCON_ADDR)                  LVDCON;
__sfr  __at (WPUDA_ADDR)                   WPUDA;
__sfr  __at (IOCA_ADDR)                    IOCA;
__sfr  __at (WDA_ADDR)                     WDA;
__sfr  __at (VRCON_ADDR)                   VRCON;
__sfr  __at (EEDAT_ADDR)                   EEDAT;
__sfr  __at (EEDATA_ADDR)                  EEDATA;
__sfr  __at (EEADR_ADDR)                   EEADR;
__sfr  __at (EECON1_ADDR)                  EECON1;
__sfr  __at (EECON2_ADDR)                  EECON2;
__sfr  __at (CRCON_ADDR)                   CRCON;
__sfr  __at (CRDAT0_ADDR)                  CRDAT0;
__sfr  __at (CRDAT1_ADDR)                  CRDAT1;
__sfr  __at (CRDAT2_ADDR)                  CRDAT2;
__sfr  __at (CRDAT3_ADDR)                  CRDAT3;

// 
// bitfield definitions
// 
volatile __CMCON0_bits_t __at(CMCON0_ADDR) CMCON0_bits;
volatile __CMCON1_bits_t __at(CMCON1_ADDR) CMCON1_bits;
volatile __CRCON_bits_t __at(CRCON_ADDR) CRCON_bits;
volatile __EECON1_bits_t __at(EECON1_ADDR) EECON1_bits;
volatile __GPIO_bits_t __at(GPIO_ADDR) GPIO_bits;
volatile __INTCON_bits_t __at(INTCON_ADDR) INTCON_bits;
volatile __IOCA_bits_t __at(IOCA_ADDR) IOCA_bits;
volatile __LVDCON_bits_t __at(LVDCON_ADDR) LVDCON_bits;
volatile __OPTION_REG_bits_t __at(OPTION_REG_ADDR) OPTION_REG_bits;
volatile __OSCCON_bits_t __at(OSCCON_ADDR) OSCCON_bits;
volatile __OSCTUNE_bits_t __at(OSCTUNE_ADDR) OSCTUNE_bits;
volatile __PCON_bits_t __at(PCON_ADDR) PCON_bits;
volatile __PIE1_bits_t __at(PIE1_ADDR) PIE1_bits;
volatile __PIR1_bits_t __at(PIR1_ADDR) PIR1_bits;
volatile __PORTA_bits_t __at(PORTA_ADDR) PORTA_bits;
volatile __STATUS_bits_t __at(STATUS_ADDR) STATUS_bits;
volatile __T1CON_bits_t __at(T1CON_ADDR) T1CON_bits;
volatile __VRCON_bits_t __at(VRCON_ADDR) VRCON_bits;
volatile __WDA_bits_t __at(WDA_ADDR) WDA_bits;
volatile __WDTCON_bits_t __at(WDTCON_ADDR) WDTCON_bits;
volatile __WPUDA_bits_t __at(WPUDA_ADDR) WPUDA_bits;

