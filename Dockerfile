FROM quay.io/pypa/manylinux1_x86_64

WORKDIR /io

ENV PATH=/opt/python/cp36-cp36m/bin:$PATH
RUN pip install pip wheel setuptools auditwheel --upgrade

COPY pycosat.c .
COPY picosat.c .
COPY picosat.h .
COPY README.rst .
COPY test_pycosat.py .
COPY setup.py .

RUN python setup.py build_ext -i
RUN python test_pycosat.py

RUN python setup.py bdist_wheel
RUN auditwheel repair ./dist/pycosat* -w ./dist/repaired
