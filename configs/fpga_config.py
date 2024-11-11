from m5.objects import *
from gem5.utils import get_cpu_class
from gem5.runtime import SimpleOpts
from gem5.configs.common.Caches import *

system = System()

system.clk_domain = SrcClockDomain()
system.clk_domain.clock = '1GHz'
system.clk_domain.voltage_domain = VoltageDomain()

system.cpu = TimingSimpleCPU()

system.membus = SystemXBar()

system.cpu.icache = L1ICache(size='16kB', assoc=4, latency='1ns')
system.cpu.dcache = L1DCache(size='16kB', assoc=4, latency='1ns')

system.cpu.icache.connectCPU(system.cpu)
system.cpu.dcache.connectCPU(system.cpu)

system.cpu.icache.mem_side = system.membus.slave
system.cpu.dcache.mem_side = system.membus.slave

system.l2cache = L2Cache(size='128kB', assoc=8, latency='5ns')
system.l2cache.cpu_side = system.membus.master
system.l2cache.mem_side = system.membus.slave

system.mem_ctrl = DDR3_1600_8x8()
system.mem_ctrl.range = AddrRange('512MB')
system.mem_ctrl.port = system.membus.master

process = Process()
process.cmd = [sys.argv[1]] #Fix this
system.cpu.workload = process
system.cpu.createThreads()

system.system_port = system.membus.slave

root = Root(full_system=False, system=system)
m5.instantiate()

print("Beginning FPGA-like gem5 simulation!")
exit_event = m5.simulate()

print(f"Simulation ended at tick {m5.curTick()} because {exit_event.getCause()}")

