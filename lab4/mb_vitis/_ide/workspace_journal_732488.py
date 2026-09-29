# 2026-09-23T17:57:19.359090
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_vitis")

platform = client.get_component(name="mb_led_gpio")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

comp = client.get_component(name="mb_led_gpio_app")
comp.build()

comp.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa")

status = platform.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

comp.build()

vitis.dispose()

