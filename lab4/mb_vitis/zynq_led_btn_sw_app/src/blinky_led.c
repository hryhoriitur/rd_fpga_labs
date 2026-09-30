#include "xparameters.h"
#include "xstatus.h"
#include "xgpio.h"
#include "xtmrctr.h"
#include "xinterrupt_wrap.h"

#include <stdint.h>
#include <stdbool.h>

#define LEDS_BASEADDR      XPAR_LEDS_GPIO_BASEADDR
#define PAUSE_BTN_BASEADDR XPAR_PAUSE_BTN_GPIO_BASEADDR
#define DIR_SW_BASEADDR    XPAR_DIR_SW_GPIO_BASEADDR

#define LEDS_NUM 4
#define LEDS_MASK  ((1 << LEDS_NUM) - 1)

#define TIMER_BASEADDR    XPAR_AXI_TIMER_0_BASEADDR

#define LED_UPDATE_PERIOD 100
// set CLOCK_SYM_DIVIDER = 10000 to speedup simulation
#define CLOCK_SYM_DIVIDER 1
// set lower timeout to sample button at higher frequency
#define TIMER_TIMEOUT     (XPAR_AXI_TIMER_0_CLOCK_FREQUENCY / (CLOCK_SYM_DIVIDER * LED_UPDATE_PERIOD))
#define TIMER_COUNTER_ID  0

int main()
{
    uint32_t led_counter = 0;

    XGpio leds_gpio, pause_btn_gpio, dir_sw_gpio;
    XTmrCtr timer_counter;

    XGpio_Config *cfg_ptr;

    cfg_ptr = XGpio_LookupConfig(LEDS_BASEADDR);
    XGpio_CfgInitialize(&leds_gpio, cfg_ptr, cfg_ptr->BaseAddress);

    cfg_ptr = XGpio_LookupConfig(DIR_SW_BASEADDR);
    XGpio_CfgInitialize(&dir_sw_gpio, cfg_ptr, cfg_ptr->BaseAddress);

    cfg_ptr = XGpio_LookupConfig(PAUSE_BTN_BASEADDR);
    XGpio_CfgInitialize(&pause_btn_gpio, cfg_ptr, cfg_ptr->BaseAddress);

    XGpio_SetDataDirection(&leds_gpio, 1, ~LEDS_MASK);
    XGpio_SetDataDirection(&pause_btn_gpio, 1, 1);
    XGpio_SetDataDirection(&dir_sw_gpio, 1, 1);
    
    XGpio_DiscreteWrite(&leds_gpio, 1, led_counter & LEDS_MASK);

    XStatus ret = XTmrCtr_Initialize(&timer_counter, TIMER_BASEADDR);
    if (ret)
        return ret;

    ret = XTmrCtr_SelfTest(&timer_counter, TIMER_COUNTER_ID);
    if (ret)
        return ret;

    XTmrCtr_SetOptions(&timer_counter, TIMER_COUNTER_ID,
                       XTC_AUTO_RELOAD_OPTION |
                       XTC_DOWN_COUNT_OPTION);

    XTmrCtr_SetResetValue(&timer_counter, TIMER_COUNTER_ID, TIMER_TIMEOUT);
    XTmrCtr_Start(&timer_counter, TIMER_COUNTER_ID);

    unsigned long ticks = 0;
    bool dir_up = true;
    bool paused = false;
    bool btn_prev = false;

    while (true) {
        if (XTmrCtr_IsExpired(&timer_counter, TIMER_COUNTER_ID)) {
            ++ticks;

            bool btn_value = XGpio_DiscreteRead(&pause_btn_gpio, 1);
            if (btn_value != btn_prev && btn_value) {
                paused = !paused;
            }
            btn_prev = btn_value;

            XTmrCtr_Reset(&timer_counter, TIMER_COUNTER_ID);
        }
        
        if (ticks == LED_UPDATE_PERIOD) {
            ticks = 0;
            if (!paused) {
                dir_up = XGpio_DiscreteRead(&dir_sw_gpio, 1);
                led_counter = led_counter + (dir_up ? 1 : -1);
                XGpio_DiscreteWrite(&leds_gpio, 1, led_counter);
            }
        }
    };

    return XST_SUCCESS;
}
