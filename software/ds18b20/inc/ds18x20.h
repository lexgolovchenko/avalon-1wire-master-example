
#ifndef DS18X20_H_
#define DS18X20_H_

#include <alt_types.h>
#include <owm_id.h>

#define DS18x20_CONVERT_T		 	(0x44)
#define DS18x20_WRITE_SCRATCHPAD 	(0x4e)
#define DS18x20_READ_SCRATCHPAD	 	(0xbe)


#define DS18B20_FAMILY_ID			(0x28)
#define DS18S20_FAMILY_ID			(0x10)


typedef union ds18x20_read_data_ {
	struct {
		unsigned char t_lsb;
		unsigned char t_msb;
		unsigned char reserved[6];
		unsigned char crc;
	} s;
	unsigned char m[9];
} ds18x20_read_data_t;


extern int ds18b20_init(alt_u32 base, owm_id_t *id);

extern int ds18x20_check_read_crc(ds18x20_read_data_t *rd);
extern int ds18x20_read_scratchpad(alt_u32 base, owm_id_t *id, ds18x20_read_data_t *data);
extern int ds18x20_convert_t(alt_u32 base, owm_id_t *id);

#endif
