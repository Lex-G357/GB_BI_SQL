/*
Урок 3. Вебинар. 
Введение в проектирование БД

Практическое задание по теме 
“Введение в проектирование БД”
Написать cкрипт, добавляющий в БД vk, которую 
создали на 3 вебинаре, 3-4 новые таблицы 
(с перечнем полей, указанием индексов и 
внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М)
*/

use vk;

drop table if exists status_on_page
create table status_on_page(
	id serial,
	user_id bigint unsigned not null,
	body varchar(255),
	
	 foreign key (user_id) references users(id) on update cascade on delete cascade
);

drop table if exists music_group
create table music_group(
	id serial,
	user_id bigint unsigned not null,
	music_type_id bigint unsigned not null,
	body varchar(255),
	filename varchar(255),
	metadata json,
	
	created_at datetime default now(),
    updated_at datetime on update current_timestamp,
    
    foreign key (user_id) references users(id) on update cascade on delete cascade,
    foreign key (music_type_id) references media_types(id) on update cascade on delete cascade
);

drop table if exists online_cine
create table online_cine(
	id serial,
	user_id bigint unsigned not null,
	cine_type_id bigint unsigned not null,
	body varchar(255),
	filename varchar(255),
	metadata json,
	
	index(cine_type_id, filename),
	
	created_at datetime default now(),
    updated_at datetime on update current_timestamp,
    
    foreign key (user_id) references users(id) on update cascade on delete cascade,
    foreign key (cine_type_id) references media_types(id) on update cascade on delete cascade
);
	
	
	













































