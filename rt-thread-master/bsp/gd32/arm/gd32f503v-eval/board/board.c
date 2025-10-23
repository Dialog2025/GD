/*
 * Copyright (c) 2006-2024, RT-Thread Development Team
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Change Logs:
 * Date           Author       Notes
 * 2024-10-22     RT-Thread    first implementation for GD32F50x
 */

#include <stdint.h>
#include <rthw.h>
#include <rtthread.h>

#include "board.h"

/* Function declarations */
#ifdef RT_USING_PIN
extern int rt_hw_pin_init(void);
#endif

#ifdef RT_USING_SERIAL
extern int rt_hw_usart_init(void);
#endif

/**
 * @brief  System Clock Configuration
 *         The system Clock is configured as follow :
 *            System Clock source            = PLL (HSE)
 *            SYSCLK(Hz)                     = 120000000
 *            HCLK(Hz)                       = 120000000
 *            AHB Prescaler                  = 1
 *            APB1 Prescaler                 = 2
 *            APB2 Prescaler                 = 1
 *            HSE Frequency(Hz)              = 25000000
 *            PLL_M                          = 25
 *            PLL_N                          = 240
 *            PLL_P                          = 2
 *            Flash Latency(WS)              = 3
 * @param  None
 * @retval None
 */
void SystemClock_Config(void)
{
    /* configure system clock */
    rcu_deinit();
    
    /* enable HXTAL oscillator */
    rcu_osci_on(RCU_HXTAL);
    rcu_osci_stab_wait(RCU_HXTAL);
    
    /* configure PLL0 */
    rcu_pll0_config(RCU_PLL0SRC_HXTAL, RCU_PLL0_MUL30, RCU_PLL0_DIV2);
    
    /* enable PLL0 */
    rcu_osci_on(RCU_PLL0_CK);
    rcu_osci_stab_wait(RCU_PLL0_CK);
    
    /* configure AHB */
    rcu_ahb_clock_config(RCU_AHB_CKSYS_DIV1);
    
    /* configure APB1, APB2 */
    rcu_apb1_clock_config(RCU_APB1_CKAHB_DIV2);
    rcu_apb2_clock_config(RCU_APB2_CKAHB_DIV1);
    
    /* Flash wait states are configured automatically by hardware */
    
    /* select PLL0P as system clock */
    rcu_system_clock_source_config(RCU_CKSYSSRC_PLL0P);
    
    /* wait until PLL0P is selected as system clock */
    while(RCU_SCSS_PLL0P != rcu_system_clock_source_get()) {
    }
    
    /* update system core clock */
    SystemCoreClockUpdate();
}

/**
 * This function will initial GD32 board.
 */
void rt_hw_board_init()
{
    /* NVIC Configuration */
#define NVIC_VTOR_MASK              0x3FFFFF80
#ifdef  VECT_TAB_RAM
    /* Set the Vector Table base location at 0x20000000 */
    SCB->VTOR  = (0x20000000 & NVIC_VTOR_MASK);
#else  /* VECT_TAB_FLASH  */
    /* Set the Vector Table base location at 0x08000000 */
    SCB->VTOR  = (0x08000000 & NVIC_VTOR_MASK);
#endif

    SystemClock_Config();

#ifdef RT_USING_PIN
    rt_hw_pin_init();
#endif

#ifdef RT_USING_SERIAL
    rt_hw_usart_init();
#endif

#ifdef RT_USING_HEAP
    rt_system_heap_init((void *)HEAP_BEGIN, (void *)HEAP_END);
#endif

#ifdef RT_USING_CONSOLE
    rt_console_set_device(RT_CONSOLE_DEVICE_NAME);
#endif

#ifdef RT_USING_COMPONENTS_INIT
    rt_components_board_init();
#endif
}