/*!
    \file    main.c
    \brief   running led

    \version 2024-03-18, V1.0.0, demo for GD32G5x3
*/

/*
    Copyright (c) 2024, GigaDevice Semiconductor Inc.

    Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this 
       list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice, 
       this list of conditions and the following disclaimer in the documentation 
       and/or other materials provided with the distribution.
    3. Neither the name of the copyright holder nor the names of its contributors 
       may be used to endorse or promote products derived from this software without 
       specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
OF SUCH DAMAGE.
*/

#include "gd32g5x3.h"
#include <rtthread.h>
#include <rtdevice.h>
#include <board.h>
#include <drv_gpio.h>
#include <drv_spi.h>
#include <stdio.h>
#include <string.h>

#define GD32G5x3_GPIO_TEST
#define LED1_PIN GET_PIN(E, 3)
#define LED2_PIN GET_PIN(E, 4)
#define LED3_PIN GET_PIN(E, 5)
#define LED4_PIN GET_PIN(E, 6)
#define EXIT_PIN GET_PIN(C, 13)

#define GD32G5x3_GPIO_TEST
#define LED1_PIN GET_PIN(E, 3)
#define LED2_PIN GET_PIN(E, 4)
#define LED3_PIN GET_PIN(E, 5)
#define LED4_PIN GET_PIN(E, 6)
#define EXIT_PIN GET_PIN(C, 13)

/* retarget the C library printf function to the USART */
#define uart_test USART0
#define UART_NAME "uart0"
#define Exit_Test     
#define GD32G5x3_I2C_EEPROM_TEST
#define GD32G5x3_SPI_TEST
#ifdef GD32G5x3_SPI_TEST
#define BUS_NAME     "spi1"
#define SPI_NAME     "spi00"

uint8_t send_id = 0x9F;
uint8_t WREN = 0x06;
uint8_t WRITE = 0x02;
uint8_t READ = 0x03;
uint8_t SE = 0x20;
uint8_t recei_id[4] = {0};
uint8_t  tx_buffer[200];
uint8_t  rx_buffer[200];

static void spi_sample(void);
#endif


#ifdef GD32G5x3_I2C_EEPROM_TEST
#include "at24cxx.h"

rt_uint8_t buf[16];

#define I2C_SERIAL "i2c2"
uint8_t i2c_24c02_test(void);
#endif
int test=1;
#define BUFFER_SIZE    256
//int fputc(int ch, FILE *f)
//{
//    usart_data_transmit(uart_test, (uint8_t)ch);
//    while(RESET == usart_flag_get(uart_test, USART_FLAG_TBE));
//    return ch;
//}


void user_pin_irq_handler(void *args)
{
    test=!test;
}
int main(void)
{

#ifdef GD32G5x3_I2C_EEPROM_TEST
    struct rt_i2c_bus_device *i2c2_dev;
    i2c2_dev = rt_i2c_bus_device_find(I2C_SERIAL);
    if(i2c_24c02_test() != 0){
        printf("I2C-AT24C02 test passed!\n\r");
    }
#endif

#ifdef GD32G5x3_SPI_TEST
    spi_sample();
#endif

#if defined UART_NAME
    rt_device_t serial;

    char buf[32];
    rt_size_t size;
 
    serial = rt_device_find(UART_NAME);
    if (serial == RT_NULL)
    {
        rt_kprintf("find %s failed!\n", UART_NAME);
        return -1;
    }

    rt_device_open(serial, RT_DEVICE_OFLAG_RDWR | RT_DEVICE_FLAG_INT_RX);

    rt_console_set_device(UART_NAME);
  
    rt_device_write(serial, 0, "Hello UART2!\r\n", 14);

#endif

    /* intialize lED1 */

#ifdef GD32G5x3_GPIO_TEST
#ifdef Exit_Test
    rcu_periph_clock_enable(RCU_GPIOC);	 
    // // 1. 配置引脚为输入模式（添加上拉电阻）
    gpio_mode_set(GPIOC, GPIO_MODE_INPUT, GPIO_PUPD_NONE, GPIO_PIN_13);
    rt_pin_attach_irq(EXIT_PIN, PIN_IRQ_MODE_FALLING, user_pin_irq_handler, RT_NULL);
    rt_pin_irq_enable(EXIT_PIN, PIN_IRQ_ENABLE);
		
 #endif
    /* set LED1 pin mode to output */

    rt_pin_mode(LED1_PIN, PIN_MODE_OUTPUT);
    rt_pin_mode(LED2_PIN, PIN_MODE_OUTPUT);
    rt_pin_mode(LED3_PIN, PIN_MODE_OUTPUT);
    rt_pin_mode(LED4_PIN, PIN_MODE_OUTPUT);

#else
    gd_eval_led_init(LED1);
    gd_eval_key_init(KEY_USER,KEY_MODE_GPIO);
#endif

    while (1)
    {
#ifdef GD32G5x3_GPIO_TEST
        if(test){
            rt_pin_write(LED4_PIN, PIN_LOW);
            rt_pin_write(LED1_PIN, PIN_HIGH);
            rt_thread_mdelay(100);
            rt_pin_write(LED1_PIN, PIN_LOW);

            rt_pin_write(LED2_PIN, PIN_HIGH);
            rt_thread_mdelay(100);
            rt_pin_write(LED2_PIN, PIN_LOW);
        }
        rt_pin_write(LED3_PIN, PIN_HIGH);
        rt_thread_mdelay(100);
        rt_pin_write(LED3_PIN, PIN_LOW);

        rt_pin_write(LED4_PIN, PIN_HIGH);

        rt_thread_mdelay(100);

#endif
    }

    return RT_EOK;
}
void test_msh(void){
printf("the st shan ");
}
MSH_CMD_EXPORT(test_msh,test_msh);


#ifdef GD32G5x3_SPI_TEST

static void spi_sample(void)
{

    uint8_t address[4] = {0x20,00,00,04};
    uint8_t waddress[4] = {0x02,00,00,04};
    uint8_t raddress[4] = {0x03,00,00,04};
    int i = 0;  
    static struct rt_spi_device *spi_dev = RT_NULL;
    struct rt_spi_configuration cfg;
    
    for(i = 0; i < 200; i ++){
            tx_buffer[i] = i;
        }
				
    spi_dev = (struct rt_spi_device *)rt_malloc(sizeof(struct rt_spi_device));
    rt_hw_spi_device_attach(BUS_NAME, SPI_NAME, GET_PIN(A, 4));

    cfg.data_width = 8;
    cfg.mode   = RT_SPI_MASTER | RT_SPI_MODE_0 | RT_SPI_MSB;
    cfg.max_hz =  2 *1000 *1000;

    spi_dev = (struct rt_spi_device *)rt_device_find(SPI_NAME);
    spi_dev->bus->owner = spi_dev;
    if (RT_NULL == spi_dev)
    {
        rt_kprintf("spi sample run failed! can't find %s device!\n", SPI_NAME);
    }
    rt_spi_configure(spi_dev, &cfg);

    /* READ FLASH ID */
    rt_spi_send_then_recv((struct rt_spi_device *)spi_dev, (uint8_t *)&send_id, 1,(uint8_t *)recei_id, 3);
    rt_kprintf("use rt_spi_transfer_message() read gd25q ID is:%x,%x,%x\n", recei_id[0], recei_id[1],recei_id[2]);

    /* WRITE ENABLE */
    rt_spi_transfer((struct rt_spi_device *)spi_dev, (uint8_t *)&WREN,(uint8_t *)recei_id, 1);

    /* ERASE SECTOR */
    rt_spi_transfer((struct rt_spi_device *)spi_dev, (uint8_t *)address,(uint8_t *)recei_id, 4);
    rt_thread_mdelay(100);

    /* WRITE ENABLE */
    rt_spi_transfer((struct rt_spi_device *)spi_dev, (uint8_t *)&WREN,(uint8_t *)recei_id, 1);

    /* WRITE TO PAGE */
    rt_spi_send_then_send((struct rt_spi_device *)spi_dev, (uint8_t *)waddress, 4,(uint8_t *)tx_buffer, 200);
    rt_thread_mdelay(50);

    /* READ TO BUFFER */
    rt_spi_send_then_recv((struct rt_spi_device *)spi_dev, (uint8_t *)raddress, 4,(uint8_t *)rx_buffer, 200);
    rt_thread_mdelay(20);
    if(0 == memcmp(rx_buffer, tx_buffer, 200)) {
        rt_kprintf("spi flash write and read test success.\r\n");
    } else {
        rt_kprintf("spi flash write and read test failed.\r\n");
    }

}

MSH_CMD_EXPORT(spi_sample, dspi_sample);
#endif

#ifdef GD32G5x3_I2C_EEPROM_TEST

uint8_t i2c_24c02_test(void)
{
    at24cxx_device_t ati2c;
    ati2c = at24cxx_init(I2C_SERIAL, 0x00);
    
    if (ati2c != NULL)
    {
       rt_kprintf("\r\n Found eeprom \r\n");
    
    }
    uint16_t i;
    uint8_t i2c_buffer_write[BUFFER_SIZE] = {0};
    uint8_t i2c_buffer_read[BUFFER_SIZE] = {0};

    rt_kprintf("\r\n I2C-AT24C02 writing...\r\n");

    /* initialize i2c_buffer_write */
    for(i = 0; i < BUFFER_SIZE; i++) {
        i2c_buffer_write[i] = i;
    }
    /* EEPROM data write */
    if(at24cxx_page_write(ati2c,0x00,i2c_buffer_write, BUFFER_SIZE) == RT_EOK) {
           rt_kprintf("I2C-AT24C02 Finish writing...\r\n");
    }
    
    rt_kprintf("I2C-AT24C02 reading...\r\n");
    /* EEPROM data read */
    if(at24cxx_page_read(ati2c,0x00,i2c_buffer_read, BUFFER_SIZE) == RT_EOK) {
           rt_kprintf("I2C-AT24C02 Finish reading...\r\n");
    }
    /* compare the read buffer and write buffer */
    for(i = 0; i < BUFFER_SIZE; i++) {
        if(i2c_buffer_read[i] != i2c_buffer_write[i]) {
            rt_kprintf("0x%02X ", i2c_buffer_read[i]);
            rt_kprintf("\r\n rr:data read and write aren't matching.\n\r");
            return 0;
        }
    }
    return 1;
}
#endif
