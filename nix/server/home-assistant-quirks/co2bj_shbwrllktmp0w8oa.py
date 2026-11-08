from tuya_device_handlers import TUYA_QUIRKS_REGISTRY
from tuya_device_handlers.builder import DeviceQuirk
from tuya_device_handlers.const import DPMode

(
    DeviceQuirk()
    .applies_to(product_id="shbwrllktmp0w8oa")
    .add_dpid_integer(
        dpid=2,
        dpcode="co2_value",
        dpmode=DPMode.READ,
        unit="ppm",
        min=0,
        max=5000,
        scale=0,
        step=1,
        report_type=None,
    )
    .add_dpid_integer(
        dpid=18,
        dpcode="temp_current",
        dpmode=DPMode.READ,
        unit="℃",
        min=-400,
        max=2000,
        scale=0,
        step=1,
        report_type=None,
    )
    .add_dpid_integer(
        dpid=19,
        dpcode="humidity_value",
        dpmode=DPMode.READ,
        unit="%",
        min=0,
        max=100,
        scale=0,
        step=1,
        report_type=None,
    )
    .register(TUYA_QUIRKS_REGISTRY)
)
