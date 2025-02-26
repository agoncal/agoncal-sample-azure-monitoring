drop table if exists TABLE_STATISTICS cascade;
drop sequence if exists TABLE_STATISTICS_SEQ;

create sequence TABLE_STATISTICS_SEQ start 1 increment 50;

create table TABLE_STATISTICS
(
  id                bigint not null,
  BITES_FOR_MEMORY  integer,
  duration          numeric(21, 0),
  JAVA_RUNTIME      varchar(255),
  DONE_AT           timestamp(6) with time zone,
  ITERATION_FOR_CPU bigint,
  description       TEXT,
  primary key (id)
);
