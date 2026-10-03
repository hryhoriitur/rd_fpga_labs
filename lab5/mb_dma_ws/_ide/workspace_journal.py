# 2026-10-06T18:17:39.895291
import vitis

client = vitis.create_client()
client.set_workspace(path="mb_dma_ws")

platform = client.get_component(name="mb_dma_btn_platform")
status = platform.update_hw(hw_design = "$COMPONENT_LOCATION/../../mb_dma_hw/mb_dma_btn_wrapper.xsa")

status = platform.build()

comp = client.get_component(name="mb_dma_btn_app")
comp.build()

comp.build()

comp.build()

