FROM texlive/texlive
RUN apt-get update && apt-get install -y \
    texlive-latex-extra \
    texlive-science \
    texlive-font-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    python3 \
    python3-pip \
    dos2unix
RUN git clone https://github.com/MODFLOW-USGS/usgslatex.git && cd usgslatex/usgsLaTeX && ./install.sh --all-users
RUN pip install flaky flopy mfpymake modflow-devtools pytest
