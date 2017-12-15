
#include <unistd.h>

#include <io.h>
#include <system.h>

#include <owm_init.h>
#include <owm_search.h>
#include <ds18x20.h>

#define MAX_SENS_NUM 15

owm_id_t sens_ids[MAX_SENS_NUM];
ds18x20_read_data_t rd_buf;
short tmpr [MAX_SENS_NUM];

int main()
{
    int sw;
    int sens_num;
    int i;
    short t;

    IOWR(PIO_0_LED_BASE, 0, 0);

    // Configure 1-wire master
    owm_init(OWM_AVALON_SLAVE_0_BASE);

    // Find all connected sensors
    sens_num = owm_search(OWM_AVALON_SLAVE_0_BASE, 0, sens_ids, MAX_SENS_NUM);

    // Init sensors
    for (i = 0; i < sens_num; ++i) {
        ds18b20_init(OWM_AVALON_SLAVE_0_BASE, &sens_ids[i]);
        usleep(1000);
    }

    while (1) {
        // Measure temperature
        ds18x20_convert_t(OWM_AVALON_SLAVE_0_BASE, NULL);

        // Read temperature
        for (i = 0; i < sens_num; ++i) {
            ds18x20_read_scratchpad(OWM_AVALON_SLAVE_0_BASE, &sens_ids[i], &rd_buf);

            t = (rd_buf.s.t_msb << 8) | rd_buf.s.t_lsb;
            t = t >> 4;
            tmpr[i] = t;

            usleep(1000);
        }

        // Display on LEDs
        sw = IORD(PIO_1_SW_BASE, 0);
        if (sw == 0) {
            // Display num of sensors
            IOWR(PIO_0_LED_BASE, 0, sens_num);
        } else {
            IOWR(PIO_0_LED_BASE, 0, tmpr[sw - 1]);
        }
    }

    return 0;
}
