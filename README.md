LZ4 - Extremely fast compression
================================

LZ4 is lossless compression algorithm, providing compression speed at 400 MB/s per core, scalable with multi-cores CPU. It also features an extremely fast decoder, with speed in multiple GB/s per core, typically reaching RAM speed limits on multi-core systems.
A high compression derivative, called LZ4_HC, is also provided. It trades CPU time for compression ratio.

This is a D programming language port of the lz4 c library.
