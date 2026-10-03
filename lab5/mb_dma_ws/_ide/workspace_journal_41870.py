# 2026-10-05T19:06:36.288872
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_dma_ws")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "mb_dma_btn_platform",hw_design = "$COMPONENT_LOCATION/../../mb_dma_hw/mb_dma_btn_wrapper.xsa",os = "standalone",cpu = "microblaze_0",domain_name = "standalone_microblaze_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

platform = client.get_component(name="mb_dma_btn_platform")
status = platform.build()

comp = client.create_app_component(name="mb_dma_btn_app",platform = "$COMPONENT_LOCATION/../mb_dma_btn_platform/export/mb_dma_btn_platform/mb_dma_btn_platform.xpfm",domain = "standalone_microblaze_0")

comp = client.get_component(name="mb_dma_btn_app")
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

vitis.dispose()

