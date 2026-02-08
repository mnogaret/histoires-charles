PANDOC   = pandoc
DEFAULTS = pandoc.yaml

SRC_DIR  = md
OUT_DIR  = out

SRC = $(wildcard $(SRC_DIR)/*.md)
PDF = $(SRC:$(SRC_DIR)/%.md=$(OUT_DIR)/%.pdf)

all: $(PDF)

$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.md $(DEFAULTS)
	$(PANDOC) -d $(DEFAULTS) "$<" -o "$@"

clean:
	rm -f $(OUT_DIR)/*.pdf
