ARMGNU ?= arm-none-eabi
TARGET = hexloader.img
LIST = hexloader.list
MAP = hexloader.map
LINKER = kernel.ld
OPTS = -g -nostartfiles -march=armv7-a -mtune=cortex-a7
#OPTS = -nostartfiles -O0 -march=armv7-a -mtune=cortex-a7 
OBJECTS := main.o boot.o hex.o uart.o

all: $(TARGET) $(LIST)

rebuild: all

$(LIST) : output.elf
	$(ARMGNU)-objdump -d output.elf > $(LIST)

$(TARGET) : output.elf
	$(ARMGNU)-objcopy output.elf -O binary $(TARGET) 

$(BUILD)output.elf : $(OBJECTS) $(LINKER)
	$(ARMGNU)-ld -g --no-undefined $(OBJECTS) -Map $(MAP) -o output.elf -T $(LINKER)

%.o: $(SOURCE)%.s
	$(ARMGNU)-as -g $< -o $@

%.o: $(SOURCE)%.c
	$(ARMGNU)-gcc $(OPTS) -c $< -o $@

clean:
	rm -f *.o *.img *.elf $(LIST) $(MAP)

