
#include <owm_avalon_slave_regs.h>

void owm_init(alt_u32 base)
{
	// Setup 1-wire timings
	IOWR_OWM_CLK_PRECL(base, 50 - 1);
	IOWR_OWM_T_RESET_L(base, 480);
	IOWR_OWM_T_RESET_H(base, 480);
	IOWR_OWM_T_RESET_PD(base, 100);
	IOWR_OWM_T_WRITE_SLOT(base, 60);
	IOWR_OWM_T_WRITE_L(base, 10);
	IOWR_OWM_T_WRITE_REC(base, 2);
	IOWR_OWM_T_READ_SLOT(base, 60);
	IOWR_OWM_T_READ_L(base, 10);
	IOWR_OWM_T_READ_READ(base, 13);
	IOWR_OWM_T_READ_REC(base, 2);

	// Set bus address
	IOWR_OWM_OW_ADDR(base, 0);

	// Disable interrupt
	IOWR_OWM_IE(base, 0);

	// Clear ready bit
	IORD_OWM_STATUS(0);
}
