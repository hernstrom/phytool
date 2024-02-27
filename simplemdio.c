#include <stdint.h>
#include <string.h>
#include <net/if.h>
#include <linux/mdio.h>

#include "phytool.h"
#include "simplemdio.h"

void _setup_loc(const char* port_name, uint8_t phy_addr, uint8_t dev_type, uint16_t reg_addr, int is_c45, struct loc *loc)
{
	strncpy(loc->ifnam, port_name, IFNAMSIZ - 1);
	loc->phy_id = is_c45 ? mdio_phy_id_c45(phy_addr, dev_type): phy_addr;
	loc->reg = reg_addr;

	return;
}

void phy_read_c45 (const char* port_name, uint8_t phy_addr, uint8_t dev_type, uint16_t reg_addr, uint16_t *const reg_value)
{
	struct loc loc;

	_setup_loc(port_name, phy_addr, dev_type, reg_addr, 1, &loc);
 	*reg_value = phy_read (&loc);
    
	return; 
}

void phy_write_c45 (const char* port_name, uint8_t phy_addr, uint8_t dev_type, uint16_t reg_addr, uint16_t reg_value)
{
	struct loc loc;

	_setup_loc(port_name, phy_addr, dev_type, reg_addr, 1, &loc);
	phy_write (&loc, reg_value);

    return; 
}

void phy_read_c22 (const char* port_name, uint8_t phy_addr, uint16_t reg_addr, uint16_t *const reg_value)
{
	struct loc loc;

	_setup_loc(port_name, phy_addr, 0, reg_addr, 0, &loc);
 	*reg_value = phy_read (&loc);
    
    return; 
}

void phy_write_c22 (const char* port_name, uint8_t phy_addr, uint16_t reg_addr, uint16_t reg_value)
{
	struct loc loc;
	
	_setup_loc(port_name, phy_addr, 0, reg_addr, 0, &loc);
	phy_write (&loc, reg_value);

    return; 
}
