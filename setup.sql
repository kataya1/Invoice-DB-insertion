create table invoice(
    id int primary key,
    client_name text,
    total numeric(15,2) not null,
    time timestamp not null
);
create table invoice_details(
    id serial primary key,
    item varchar not null,
    quantity numeric(15,2) not null,
    unit text not null,
    inv_id int not null,
    foreign key (inv_id) references invoice(id)
);