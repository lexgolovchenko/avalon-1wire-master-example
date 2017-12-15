
#include <ds18x20.h>
#include <owm_avalon_slave.h>
#include <owm_crc.h>

/*
 * 0, 1 - temperature threshold for alarm mode (not used!)
 *
 * 2 - config data, [4:0] = 0x1f, [6:5] = measurements resolution:
 *  	0 - 9-bit   (0x1f)
 *  	1 - 10-bit  (0x3f)
 *  	2 - 11-bit  (0x5f)
 *  	3 - 12-bit  (0x7f)
 */
static unsigned char ds18b20_init_data[3] = {0x00, 0x00, 0x1f};


int ds18b20_init(alt_u32 base, owm_id_t *id)
{
	if (!owm_reset(base)) {
		return -1;
	}

	owm_write_byte(base, id ? OWM_MATCH_ROM : OWM_SKIP_ROM);
	if (id) {
		owm_write_data(base, id->m, 8);
	}
	owm_write_byte(base, DS18x20_WRITE_SCRATCHPAD);
	owm_write_data(base, ds18b20_init_data, 3);
	return 0;
}


int ds18x20_check_read_crc(ds18x20_read_data_t *rd)
{
	return (rd->s.crc == owm_crc8(rd->m, 8)) ? 0 : -1;
}


int ds18x20_read_scratchpad(alt_u32 base, owm_id_t *id, ds18x20_read_data_t *data)
{
	if (!owm_reset(base)) {
		return -1;
	}

	owm_write_byte(base, id ? OWM_MATCH_ROM : OWM_SKIP_ROM);
	if (id) {
		owm_write_data(base, id->m, 8);
	}
	owm_write_byte(base, DS18x20_READ_SCRATCHPAD);
	owm_read_data(base, data->m, 9);

	return ds18x20_check_read_crc(data);
}


int ds18x20_convert_t(alt_u32 base, owm_id_t *id)
{
	if (!owm_reset(base))
		return -1;

	owm_write_byte(base, id ? OWM_MATCH_ROM : OWM_SKIP_ROM);
	if (id) {
		owm_write_data(base, id->m, 8);
	}
	owm_write_byte(base, DS18x20_CONVERT_T);

	// Wait while any slaves hold the bus
	while (1) {
		if (owm_read_bit(base)) {
			break;
		}
	}

	return 0;
}
