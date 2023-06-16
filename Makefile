TIMER		= 60
FILE_COUNT	= 30
FILENAME	= service1-%Y-%m-%d_%H.%M.%S.pcap
DUMP_CMD	= sudo tcpdump -G $(TIMER) -W $(FILE_COUNT) -w $(FILENAME) -s0 -i game 'tcp and port PORT'

COMPOSE		= sudo docker-compose
YML			= caronte/docker-compose.yml
DC			= $(COMPOSE) -f $(YML)

TEAM		= 9
VM_IP		= 10.60.$(TEAM).1


# Docker

all: up

build:
	$(DC) up -d --build

up:
	$(DC) up -d

down:
	$(DC) down

start:
	$(DC) start

stop:
	$(DC) stop



# Traffic and SSH

sniff:
	./import_pcaps.sh $(VM_IP)

scp_dump:
	scp ./dump.sh root@$(VM_IP):/root/dump.sh

ssh_copy_id:
	ssh-copy-id -i ~/.ssh/id_rsa.pub root@$(VM_IP)

ssh: ssh_copy_id
	ssh root@$(VM_IP)

dump: ssh_copy_id scp_dump
	ssh root@$(VM_IP) bash dump.sh
	./import_pcaps.sh $(VM_IP)



# Help

help:
	@ echo "Remember to insert the id_rsa.pub in the VM"
	@ echo "create the /root/pcaps/service* subforlders"
	@ echo "sudo chmod -R 777 ."
	@ echo "enter into screen to dump:"
	@ echo $(DUMP_CMD)

	@ echo "screen -S name	-> to create a session named 'name'"
	@ echo "screen			-> create a session without name"
	@ echo "screen -r name	-> recover the session"
	@ echo "screen -dr name	-> recover the detached session"
	@ echo "<CTRL-a> + d	-> detach"
	@ echo "<CTRL-d>		-> kill session"
	@ echo "screen -ls		-> list sessions"



# Phony

.PHONY: all build up down start stop sniff scp_dump ssh_copy_id ssh dump help
