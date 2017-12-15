
#ifndef __OWM_CRC_H_INCLUDED__
#define __OWM_CRC_H_INCLUDED__

extern unsigned char owm_crc8(unsigned char *data, int size);
extern void owm_crc8_step(unsigned char val, unsigned char *crc);

#endif
