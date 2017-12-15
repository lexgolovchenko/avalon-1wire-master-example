
#include <owm_avalon_slave.h>
#include <owm_search.h>
#include <owm_crc.h>

/*
 * Search slave devices on 1-wire bus
 */
int owm_search(int base, int alarm, owm_id_t *ids, int ids_num)
{
	int id_bit, cmp_id_bit, id_bit_num;
	int last_device_flag;
	int last_discrepancy;
	int last_zero;
	int search_direction;
	int cur_dev_num;

	owm_id_t cur_id, last_id;

	if (ids_num < 1)
		goto ERROR;

	last_discrepancy = 0;
	last_device_flag = 0;
	cur_dev_num = 0;
	last_id.w = 0;
	while (1) {
		if (!owm_reset(base))
			goto ERROR;

		if (last_device_flag)
			break;

		owm_write_byte(base, alarm ? OWM_ALARM_SEARCH : OWM_SEARCH_ROM);

		id_bit_num = 1;
		last_zero = 0;
		cur_id.w = 0;
		while (1) {
			id_bit = owm_read_bit(base);
			cmp_id_bit = owm_read_bit(base);

			if (id_bit && cmp_id_bit) {
				goto ERROR;
			} else if (!id_bit && !cmp_id_bit) {
				if (id_bit_num == last_discrepancy)
					search_direction = 1;
				else if (id_bit_num > last_discrepancy)
					search_direction = 0;
				else
					search_direction = (last_id.w >> (id_bit_num - 1)) & 0x01;

				if (search_direction == 0)
					last_zero = id_bit_num;
			} else {
				search_direction = id_bit;
			}

			cur_id.w = cur_id.w | (((unsigned long long)search_direction) << (id_bit_num - 1));

			owm_write_bit(base, search_direction);

			id_bit_num += 1;
			if (id_bit_num > 64)
				break;
		}

		last_discrepancy = last_zero;
		if (last_discrepancy == 0)
			last_device_flag = 1;

		if (owm_check_id_crc(&cur_id))
			goto ERROR;

		last_id.w = cur_id.w;
		if (cur_dev_num < ids_num)
			if (ids != 0)
				ids[cur_dev_num].w = cur_id.w;
		cur_dev_num += 1;
	}

	return cur_dev_num;

ERROR:
	return -1;
}
