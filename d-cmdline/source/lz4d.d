import std.stdio;
import std.getopt;
import f=std.file;
import lz4.lz4;

void printHelp(string a0)
{
	enum string helpStr=  q{{lz4d [de]compression program
Usage: %s [options] infile outfile
Options:
 infile - specifies the input file (defaults to stdin)
 outfile - specifies the output file (required)
 --decompress (-d) - decompresses input instead of compressing it}};
	writefln(helpStr,a0);
}

void main(string[] args)
{
	string infile;
	string args0 = args[0];
	string outfile;
	int clevel=1;
	bool decompress=false;
	getopt(args,
			"decompress|d",&decompress
			);
	if(args.length==3)
	{
		infile  = args[1];
		outfile = args[2];
	}
	else
	{
		printHelp(args0);
		return;
	}
	ubyte[] indata = cast(ubyte[])f.read(infile);
	ubyte[] outdata;
	if(decompress==false)
	{
		int msz = LZ4_compressBound(cast(int)indata.length);
		outdata.length = msz;
		int osz = LZ4_compress(cast(char*)indata.ptr,cast(char*)outdata.ptr,cast(int)indata.length);
		double isz = cast(double)(indata.length);
		outdata.length = osz;
		f.write(outfile, cast(void[])outdata);
		writefln("Saved %s (%d bytes, compression ratio %.5fx)\n%d\n%d\n%d",outfile,osz,isz/osz,indata.length,osz,msz);
	}
	else
	{
		int isz = cast(int)(indata.length);
		int osz = (isz*3);
		outdata.length = osz;
		osz = LZ4_decompress_safe(cast(char*)indata.ptr, cast(char*)outdata.ptr, isz, osz);
		outdata.length = osz;
		f.write(outfile, cast(void[])outdata);
		writefln("Decompressed into %s (%d bytes)",outfile,osz);
	}
}
