import sys, time, usb.core, usb.util
d = usb.core.find(idVendor=0x18d1, idProduct=0xd001)
cfg = d.get_active_configuration()
# last CDC Data interface belongs to the ACM function
data = [i for i in cfg if i.bInterfaceClass == 0x0a][-1]
ctrl_num = data.bInterfaceNumber - 1
for n in (ctrl_num, data.bInterfaceNumber):
    try:
        if d.is_kernel_driver_active(n): d.detach_kernel_driver(n)
    except Exception: pass
    usb.util.claim_interface(d, n)
# SET_CONTROL_LINE_STATE: DTR|RTS
d.ctrl_transfer(0x21, 0x22, 0x3, ctrl_num, None)
ep_out = usb.util.find_descriptor(data, custom_match=lambda e: usb.util.endpoint_direction(e.bEndpointAddress) == usb.util.ENDPOINT_OUT)
ep_in = usb.util.find_descriptor(data, custom_match=lambda e: usb.util.endpoint_direction(e.bEndpointAddress) == usb.util.ENDPOINT_IN)
def drain(t=1.5):
    out, end = b"", time.time() + t
    while time.time() < end:
        try: out += bytes(ep_in.read(4096, timeout=300))
        except usb.core.USBTimeoutError: pass
    return out
drain(0.5)
ep_out.write((sys.argv[1] + "\n").encode())
sys.stdout.write(drain(float(sys.argv[2]) if len(sys.argv) > 2 else 2).decode(errors="replace"))
