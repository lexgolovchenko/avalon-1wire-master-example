
#include <owm_avalon_slave.h>
#include <owm_id.h>
#include <owm_crc.h>

int owm_check_id_crc(owm_id_t *id)
{
	return (id->s.crc == owm_crc8(id->m, 7)) ? 0 : -1;
}

/*
 * For correct execution of READ_ROM command only one slave device allowed
 */
int owm_read_id(alt_u32 base, owm_id_t *id)
{
	if (!owm_reset(base))
		return -1;

	owm_write_byte(base, OWM_READ_ROM);
	owm_read_data(base, id->m, 8);

	return 0;
}
