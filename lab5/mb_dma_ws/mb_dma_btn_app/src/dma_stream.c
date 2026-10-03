#include "xparameters.h"
#include "xil_io.h"
#include "xaxidma.h"
#include "xgpio.h"

#include <unistd.h>
#include <stdbool.h>

#define DMA_BASEADDR      XPAR_AXI_DMA_0_BASEADDR
#define RAM_BASEADDR      XPAR_AXI4_FULL_RAM_BASEADDR
#define BUTTON_BASEADDR   XPAR_AXI_BTN_GPIO_BASEADDR
#define FIFO_EN_BASEADDR  XPAR_AXI_FIFO_EN_BASEADDR

#define DST_ADDR          (RAM_BASEADDR + 0x00)
#define WORD_SIZE         4
#define IMAGE_SIZE        320 * 20
#define DMA_TRANSFER_SIZE (IMAGE_SIZE * WORD_SIZE)

XAxiDma dma_inst;
volatile int errors = -1;   /* -1: ще не виконано, 0: дані скопійовано вірно */

int main(void)
{
    XGpio_Config *cfg_ptr;
    XGpio start_btn_gpio, fifo_en_gpio;

    cfg_ptr = XGpio_LookupConfig(BUTTON_BASEADDR);
    XGpio_CfgInitialize(&start_btn_gpio, cfg_ptr, cfg_ptr->BaseAddress);

    cfg_ptr = XGpio_LookupConfig(FIFO_EN_BASEADDR);
    XGpio_CfgInitialize(&fifo_en_gpio, cfg_ptr, cfg_ptr->BaseAddress);

    XAxiDma_Config *cfg = XAxiDma_LookupConfig(DMA_BASEADDR);
    XAxiDma_CfgInitialize(&dma_inst, cfg);

    while (true) {
        // disabled for simluation
        // usleep(1000);

        bool btn_value = XGpio_DiscreteRead(&start_btn_gpio, 1);
        if (btn_value)
            break;
    }

    XGpio_DiscreteWrite(&fifo_en_gpio, 1, 1);

    XAxiDma_SimpleTransfer(&dma_inst, DST_ADDR, DMA_TRANSFER_SIZE, XAXIDMA_DEVICE_TO_DMA);

    while (XAxiDma_Busy(&dma_inst, XAXIDMA_DEVICE_TO_DMA));

    XGpio_DiscreteWrite(&fifo_en_gpio, 1, 0);

    while (1) {}
    return 0;
}