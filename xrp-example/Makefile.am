#
# Copyright (c) 2017 Cadence Design Systems Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

AM_CPPFLAGS = -I$(srcdir)/.. -I$(srcdir)/../xrp-common
AM_CFLAGS = -W -Wall

bin_PROGRAMS =

if BUILD_STANDALONE
if BUILD_HOST
bin_PROGRAMS += xrp-host-standalone
BUILT_SOURCES = xrp.dtb
CLEANFILES = xrp.dtb
endif
if BUILD_DSP
bin_PROGRAMS += xrp-dsp-standalone
endif
endif

if BUILD_HOSTED
if BUILD_HOST
bin_PROGRAMS += xrp-host-hosted
endif
if BUILD_DSP
bin_PROGRAMS += xrp-dsp-hosted
endif
endif

if BUILD_SINGLE
if BUILD_HOST
bin_PROGRAMS += xrp-host-single
endif
endif

dsp_cppflags = $(AM_CPPFLAGS) -I$(srcdir)/../xrp-dsp
dsp_ldflags = $(AM_LDFLAGS) \
	      -mlsp=$(DSP_LSP) \
	      -Wl,--defsym,_memmap_cacheattr_reset=$(DSP_CACHEATTR)

xrp_dsp_standalone_SOURCES = dsp_main.c dsp_test.c
xrp_dsp_standalone_CPPFLAGS = $(dsp_cppflags)
xrp_dsp_standalone_LDFLAGS = $(dsp_ldflags) \
			     -Wl,--defsym,xrp_dsp_comm_base_magic=$(DSP_COMM_BASE)
xrp_dsp_standalone_LDADD = ../xrp-dsp/libxrp-dsp.a \
			   ../xrp-dsp/$(HW_PORT)/libxrp-dsp-hw-$(HW_PORT).a \
			   ../xrp-common/libxrp-common.a \
			   $(THREADS_LDFLAGS)

xrp_dsp_hosted_SOURCES = dsp_main.c dsp_test.c
xrp_dsp_hosted_CPPFLAGS = $(dsp_cppflags)
xrp_dsp_hosted_LDFLAGS = $(dsp_ldflags) \
			 -Wl,--defsym,xrp_dsp_comm_base_magic=0x20161006
xrp_dsp_hosted_LDADD = ../xrp-dsp/libxrp-dsp.a \
		       ../xrp-dsp/$(HW_PORT)/libxrp-dsp-hw-$(HW_PORT).a \
		       ../xrp-common/libxrp-common.a \
		       $(THREADS_LDFLAGS)

xrp_host_standalone_SOURCES = host_main.c xrp_dtb.s
xrp_host_standalone_CFLAGS = $(AM_CFLAGS) $(THREAD_CFLAGS)
xrp_host_standalone_LDADD = ../xrp-host/libxrp-host-standalone.a $(THREADS_LDFLAGS) $(LIBFDT_LDFLAGS) -lfdt

if HOST_OS_ELF
xrp_host_standalone_LDFLAGS = $(AM_LDFLAGS) \
			      -mlsp=$(HOST_LSP) \
			      -Wl,--defsym,_memmap_cacheattr_reset=$(HOST_CACHEATTR)
endif

if HOST_OS_LINUX
xrp_host_standalone_LDADD += -lrt
endif

xrp_host_hosted_SOURCES = host_main.c
xrp_host_hosted_CFLAGS = $(AM_CFLAGS) $(THREAD_CFLAGS)
xrp_host_hosted_LDADD = ../xrp-host/libxrp-host-hosted.a $(THREADS_LDFLAGS)

xrp_host_single_SOURCES = host_main.c dsp_test.c
xrp_host_single_LDADD = ../xrp-host/libxrp-host-single.a $(THREADS_LDFLAGS)

xrp_dtb.$(OBJEXT): xrp.dtb
xrp.dtb: $(srcdir)/xrp.dts
	$(AM_V_GEN)$(DTC) -o $@ -O dtb $<
