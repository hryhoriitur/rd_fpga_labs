# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/diskio.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/ff.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/ffconf.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/sleep.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/xilffs.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/xilffs_config.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/xilrsa.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/xiltimer.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/include/xtimer_config.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/lib/libxilffs.a"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/lib/libxilrsa.a"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/zynq_led_btn_sw/zynq_fsbl/zynq_fsbl_bsp/lib/libxiltimer.a"
  )
endif()
