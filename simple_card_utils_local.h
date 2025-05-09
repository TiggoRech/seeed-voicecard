#ifndef __SIMPLE_CARD_UTILS_LOCAL_H__
#define __SIMPLE_CARD_UTILS_LOCAL_H__

#include <linux/clk.h>
#include <linux/of.h>
#include <linux/of_platform.h>
#include <linux/slab.h>
#include <sound/soc.h>

struct asoc_simple_dai {
	const char *name;
	unsigned int sysclk;
	int clk_direction;
	unsigned int slots;
	unsigned int slot_width;
	unsigned int tx_slot_mask;
	unsigned int rx_slot_mask;
	struct clk *clk;
};

struct seeed_card_info {
	const char *name;
	const char *card;
	const char *codec;
	const char *platform;
	unsigned int daifmt;
	struct asoc_simple_dai cpu_dai;
	struct asoc_simple_dai codec_dai;
};

/* Canonicalizadores */
static inline void asoc_simple_canonicalize_cpu(struct snd_soc_dai_link_component *cpus, int is_single)
{
	if (is_single)
		cpus[0].of_node = NULL;
}

static inline void asoc_simple_canonicalize_platform(struct snd_soc_dai_link_component *platforms,
                                                     struct snd_soc_dai_link_component *cpus)
{
	platforms[0].of_node = cpus[0].of_node;
}

/* Nome do DAI */
static inline int asoc_simple_set_dailink_name(struct device *dev,
                                               struct snd_soc_dai_link *dai_link,
                                               const char *fmt, const char *s1, const char *s2)
{
	dai_link->name = devm_kasprintf(dev, GFP_KERNEL, fmt, s1, s2);
	if (!dai_link->name)
		return -ENOMEM;

	dai_link->stream_name = dai_link->name;
	return 0;
}

/* Nome da placa */
static inline int asoc_simple_parse_card_name(struct snd_soc_card *card, const char *prefix)
{
	struct device_node *np = card->dev->of_node;
	const char *str;
	char prop[64];

	snprintf(prop, sizeof(prop), "%scard-name", prefix);
	if (!of_property_read_string(np, prop, &str)) {
		card->name = str;
		return 0;
	}

	card->name = np->name;
	return 0;
}

/* Limpeza de nomes */
static inline void asoc_simple_clean_reference(struct snd_soc_card *card)
{
	if (card->name)
		card->name = NULL;

	if (card->dai_link && card->num_links > 0) {
		int i;
		for (i = 0; i < card->num_links; i++) {
			if (card->dai_link[i].name)
				card->dai_link[i].name = NULL;
			if (card->dai_link[i].stream_name)
				card->dai_link[i].stream_name = NULL;
		}
	}
}

/* Placeholder vazio */
static inline int asoc_simple_parse_daifmt(struct device *dev,
                                           struct device_node *node,
                                           struct device_node *codec,
                                           const char *prefix,
                                           unsigned int *fmt)
{
	// Use formato fixo I2S como padrão
	*fmt = SND_SOC_DAIFMT_I2S |
	       SND_SOC_DAIFMT_NB_NF |
	       SND_SOC_DAIFMT_CBS_CFS;
	return 0;
}

static inline int asoc_simple_parse_clk(struct device *dev,
                                        struct device_node *node,
                                        struct asoc_simple_dai *simple_dai,
                                        struct snd_soc_dai_link_component *dlc)
{
	// Placeholder básico sem clk real
	simple_dai->clk = NULL;
	simple_dai->clk_direction = SND_SOC_CLOCK_OUT;
	return 0;
}

#endif /* __SIMPLE_CARD_UTILS_LOCAL_H__ */
