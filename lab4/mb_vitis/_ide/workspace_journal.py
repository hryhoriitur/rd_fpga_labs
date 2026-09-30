# 2026-09-30T17:15:31.250759
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_vitis")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "zynq_led_btn_sw",hw_design = "$COMPONENT_LOCATION/../../zynq/zynq_timer_leds_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="zynq_led_btn_sw")
status = platform.build()

comp = client.create_app_component(name="zynq_led_btn_sw_app",platform = "$COMPONENT_LOCATION/../zynq_led_btn_sw/export/zynq_led_btn_sw/zynq_led_btn_sw.xpfm",domain = "standalone_ps7_cortexa9_0")

comp = client.get_component(name="zynq_led_btn_sw_app")
comp.build()

comp.build()

