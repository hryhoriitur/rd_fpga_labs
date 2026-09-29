# 2026-09-22T19:05:05.522707
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_vitis")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "mb_led_gpio",hw_design = "$COMPONENT_LOCATION/../../microblaze/mb_led_gpio_wrapper.xsa",os = "standalone",cpu = "microblaze_0",domain_name = "standalone_microblaze_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="mb_led_gpio")
status = platform.build()

comp = client.create_app_component(name="mb_led_gpio_app",platform = "$COMPONENT_LOCATION/../mb_led_gpio/export/mb_led_gpio/mb_led_gpio.xpfm",domain = "standalone_microblaze_0")

vitis.dispose()

