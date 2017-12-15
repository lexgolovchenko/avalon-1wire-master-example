
#ifndef OWM_ID_H_
#define OWM_ID_H_

#include <alt_types.h>

#define OWM_SEARCH_ROM       (0xf0)
#define OWM_READ_ROM         (0x33)
#define OWM_MATCH_ROM        (0x55)
#define OWM_SKIP_ROM         (0xcc)
#define OWM_ALARM_SEARCH     (0xec)

/*
 * ID of 1-wire slave
 */
typedef union owm_id_t_ {
	struct {
		unsigned char family;
		unsigned char id[6];
		unsigned char crc;
	} s;
	unsigned char m[8];
	unsigned long long w;
} owm_id_t;

extern int owm_check_id_crc(owm_id_t *id);
extern int owm_read_id(alt_u32 base, owm_id_t *id);


#endif
