FROM quay.io/pypa/manylinux1_x86_64

WORKDIR /io

ENV PATH=/opt/python/cp36-cp36m/bin:$PATH
# stick to wheel 0.30.0 because 0.31.0 does not generate metadata.json anymore and anaconda cant handle that
# https://github.com/Anaconda-Platform/anaconda-client/issues/469
RUN pip install pip wheel==0.30.0 setuptools auditwheel anaconda-client twine --upgrade

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
