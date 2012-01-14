# for my convenience
llvm_installation_dir = /uusoc/exports/scratch/chenyang/clang_reducer/llvm-3.0
llvm_dir = ${llvm_installation_dir}

CXX = g++
CXXFLAGS = -Werror -Wall

LLVM_CXXFLAGS = `${llvm_dir}/bin/llvm-config --cxxflags`
LLVM_LDFLAGS = `${llvm_dir}/bin/llvm-config --ldflags`
LLVM_LIBS = `${llvm_dir}/bin/llvm-config --libs`

INCLUDES = ${LLVM_CXXFLAGS} -I${llvm_dir}/include/clang/
LDFLAGS = ${LLVM_LDFLAGS}
LIBS = -lclangFrontendTool -lclangFrontend -lclangDriver -lclangSerialization \
       -lclangCodeGen -lclangParse -lclangSema -lclangAnalysis \
       -lclangIndex -lclangRewrite -lclangAST -lclangLex -lclangBasic \
       ${LLVM_LIBS} 

TRANSFORM_OBJS = FuncParamReplacement.o

OBJS = ClangDelta.o \
       TransformationManager.o \
       Transformation.o \
       ${TRANSFORM_OBJS}

.SUFFIXES : .o .cpp
.cpp.o :
	${CXX} -g ${CXXFLAGS} ${INCLUDES} -c $<

clang_delta: ${OBJS}
	${CXX} -g -o clang_delta ${OBJS} ${LDFLAGS} ${LIBS}

ClangDelta.o: ClangDelta.cpp

TransformationManager.o: TransformationManager.cpp TransformationManager.h ${TRANSFORM_OBJS}

Transformation.o: Transformation.cpp Transformation.h

FuncParamReplacement.o: FuncParamReplacement.cpp FuncParamReplacement.h Transformation.o

clean:
	rm -rf *.o

cleanall:
	rm -rf *.o clang_delta
