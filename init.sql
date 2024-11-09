create table product
(
    price    double       null,
    quantity int          null,
    id       bigint auto_increment
        primary key,
    title    varchar(255) null
);

