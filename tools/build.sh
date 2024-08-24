
export Version=14.0.6

# 1. dependences
apt install autoconf bison flex m4 libgmp-dev libmpfr-dev libssl-dev

# 2. extract source code
if [ ! -d "llvm-$Version.src" ]; then
    tar -xvf llvm-$Version.src.tar.xz

    tar -xvf clang-$Version.src.tar.xz
    mv clang-$Version.src llvm-$Version.src/tools/

    tar -xvf compiler-rt-$Version.src.tar.xz
    mv compiler-rt-$Version.src llvm-$Version.src/projects/

    cp CMakeLists.txt llvm-$Version.src/
fi

# 3. build binutils-2.37
if [ ! -d "binutils-2.37" ]; then
    tar -xvf binutils-2.37.tar.gz
fi
if [ ! -d "binu_build" ]; then mkdir binu_build; fi
cd binu_build
../binutils-2.37/configure --enable-gold --enable-plugins --disable-werro
make all-gold
cd -

# 4 compile llvm
if [ ! -d "build" ]; then mkdir build; fi
cd build	
cmake -DCMAKE_BUILD_TYPE:String=Release -DLLVM_BINUTILS_INCDIR=../binutils-2.37/include ../llvm-$Version.src
make -j4






