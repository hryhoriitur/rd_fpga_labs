# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/mb_led_gpio/microblaze_0/standalone_microblaze_0/bsp/include/sleep.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/mb_led_gpio/microblaze_0/standalone_microblaze_0/bsp/include/xiltimer.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/mb_led_gpio/microblaze_0/standalone_microblaze_0/bsp/include/xtimer_config.h"
  "/home/hryhorii.tur/edu/fpga/lab4/mb_vitis/mb_led_gpio/microblaze_0/standalone_microblaze_0/bsp/lib/libxiltimer.a"
  )
endif()
