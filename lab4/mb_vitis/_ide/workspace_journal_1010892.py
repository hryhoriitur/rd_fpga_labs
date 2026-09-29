# 2026-09-24T19:13:21.598449
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_vitis")

platform = client.get_component(name="mb_led_gpio")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

comp = client.get_component(name="mb_led_gpio_app")
comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

status = platform.build()

status = platform.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

status = platform.build()

status = platform.build()

status = platform.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

comp.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

comp.build()

vitis.dispose()

