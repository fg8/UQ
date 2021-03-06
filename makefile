# @file Makefile for paper1
# @author Soheil Hajian

#
# TODO:
#

CC := g++

CCFLAGS := -fbounds-check -fstack-check \
	   -pg -fPIC 

# -Wl : pass option as an option to the linker
LDFLAGS := -shared
LDMAC := -dynamiclib

LIB :=

SRCDIR := src
BUILDDIR := build_cpp
LIBDIR := lib
TARGET := bin

PYTHON_LIB := UQuant/lib

SRCEXT = cpp

SOURCES := $(wildcard $(SRCDIR)/*.$(SRCEXT))
OBJECTS := $(patsubst $(SRCDIR)/%, $(BUILDDIR)/%, $(SOURCES:.$(SRCEXT)=.o) )
DEP     := $(SRCDIR)/dependencies.dep

-include $(DEP)

main: $(OBJECTS)
	$(CC) $(CCFLAGS) -o $(TARGET)/$@ $(OBJECTS) $(LIB)

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	$(CC) $(CCFLAGS) -c $< -o $@ $(LIB)

$(LIBDIR)/%.so: $(BUILDDIR)/%.o
	$(CC) $(CCFLAGS) $(LDFLAGS) -Wl,-soname,$@ -o $@ $^
	cp $@ $(PYTHON_LIB)/.

$(LIBDIR)/%.dylib: $(BUILDDIR)/%.o
	$(CC) $(CCFLAGS) $(LDMAC) -Wl,-install_name,$@ -o $@ $^
	cp $@ $(basename $@).so
	mv $(LIBDIR)/*.so $(PYTHON_LIB)/.


# $(DEP): $(SRCDIR)/fort_depend.py
# 	@echo "Making dependencies..."
# 	python $(SRCDIR)/fort_depend.py -b $(BUILDDIR) -w -o $(DEP) -f $(SRCDIR)/*.$(SRCEXT)
ec:
	@echo $(basename $(LIBDIR)/CWrapper.dylib).so
clean:
	@echo "Cleaning..."
	rm -f $(BUILDDIR)/*.o $(LIBDIR)/*.so $(TARGET)/* $(PYTHON_LIB)/*.so


