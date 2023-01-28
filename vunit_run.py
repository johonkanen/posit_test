#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

# ROOT
ROOT = Path(__file__).resolve().parent
VU = VUnit.from_argv()

posit_library = VU.add_library("posit_library")
posit_library.add_source_file(ROOT / "testbenches/test_posits_tb.vhd")

VU.main()
