#define CONFIG_VERSION "2020-11-08"

#define CONFIG_QUICKJS_MINIMAL
#define CONFIG_BIGNUM

/* Отключаем ненужные возможности */
#undef CONFIG_ATOMICS
#undef CONFIG_STACK_CHECK
#undef CONFIG_DEBUG
#undef CONFIG_PROF
#undef CONFIG_DUMP_LEAKS

/* Включаем только URL */
#define CONFIG_URL