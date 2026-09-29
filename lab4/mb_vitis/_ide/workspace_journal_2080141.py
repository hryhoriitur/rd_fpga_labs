# 2026-09-28T19:23:06.593097
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_vitis")

comp = client.get_component(name="mb_led_gpio_app")
comp.build()

comp.build()

comp.build()

vitis.dispose()

