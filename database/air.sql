PGDMP                      }            air    17.4    17.2 S    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    25487    air    DATABASE     i   CREATE DATABASE air WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';
    DROP DATABASE air;
                     postgres    false            �            1255    25622 .   book_seat(integer, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.book_seat(p_user_id integer, p_flight_id integer, p_seat_number character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seat_id INT;
BEGIN
    SELECT id INTO seat_id 
    FROM seats 
    WHERE flight_id = p_flight_id AND seat_number = p_seat_number AND is_reserved = FALSE;

    IF seat_id IS NULL THEN
        RETURN 'Место уже забронировано или не существует.';
    END IF;

    UPDATE seats SET is_reserved = TRUE WHERE id = seat_id;

    INSERT INTO bookings (user_id, flight_id, seat_id)
    VALUES (p_user_id, p_flight_id, seat_id);

    RETURN 'Бронирование успешно.';
END;
$$;
 i   DROP FUNCTION public.book_seat(p_user_id integer, p_flight_id integer, p_seat_number character varying);
       public               postgres    false            �            1255    25623    cancel_booking(integer)    FUNCTION     �  CREATE FUNCTION public.cancel_booking(p_booking_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    seat_id INT;
BEGIN
    SELECT seat_id INTO seat_id FROM bookings WHERE id = p_booking_id;

    IF seat_id IS NULL THEN
        RETURN 'Бронь не найдена.';
    END IF;

    UPDATE bookings SET booking_status = 'cancelled' WHERE id = p_booking_id;
    UPDATE seats SET is_reserved = FALSE WHERE id = seat_id;

    RETURN 'Бронь отменена.';
END;
$$;
 ;   DROP FUNCTION public.cancel_booking(p_booking_id integer);
       public               postgres    false            �            1255    25624    notify_delay()    FUNCTION     �  CREATE FUNCTION public.notify_delay() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.status = 'delayed' THEN
        RAISE NOTICE 'Рейс % задерживается. Уведомление отправлено пользователям.', NEW.flight_number;
        -- Здесь можно добавить запись в отдельную таблицу уведомлений
    END IF;
    RETURN NEW;
END;
$$;
 %   DROP FUNCTION public.notify_delay();
       public               postgres    false            �            1255    25626 %   register_user(text, text, text, text)    FUNCTION     �  CREATE FUNCTION public.register_user(p_email text, p_password_hash text, p_full_name text, p_phone text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_user_id INTEGER;
BEGIN
    -- Проверка на уникальность email
    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        RAISE EXCEPTION 'Пользователь с email % уже существует.', p_email;
    END IF;

    -- Вставка в таблицу users
    INSERT INTO users (email, password_hash, full_name, phone, created_at)
    VALUES (p_email, p_password_hash, p_full_name, p_phone, NOW())
    RETURNING id INTO new_user_id;

    -- Добавление в программу лояльности (уровень basic, 0 баллов, 0% скидка)
    INSERT INTO loyalty_program (user_id, points, level, discount_percent)
    VALUES (new_user_id, 0, 'basic', 0.0);

    RETURN new_user_id;
END;
$$;
 h   DROP FUNCTION public.register_user(p_email text, p_password_hash text, p_full_name text, p_phone text);
       public               postgres    false            �            1259    25527    bookings    TABLE     �  CREATE TABLE public.bookings (
    id integer NOT NULL,
    user_id integer,
    flight_id integer,
    seat_id integer,
    booking_status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT bookings_booking_status_check CHECK (((booking_status)::text = ANY ((ARRAY['active'::character varying, 'cancelled'::character varying, 'pending'::character varying])::text[])))
);
    DROP TABLE public.bookings;
       public         heap r       postgres    false            �            1259    25512    seats    TABLE     �   CREATE TABLE public.seats (
    id integer NOT NULL,
    flight_id integer,
    seat_number character varying(10),
    is_reserved boolean DEFAULT false,
    price numeric(10,2) DEFAULT 0.00
);
    DROP TABLE public.seats;
       public         heap r       postgres    false            �            1259    25489    users    TABLE     +  CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    full_name character varying(255),
    phone character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    default_payment_method_id integer
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    25618    booking_history    VIEW     /  CREATE VIEW public.booking_history AS
 SELECT b.id,
    u.id AS user_id,
    b.flight_id,
    s.seat_number,
    b.booking_status AS status,
    b.created_at AS booking_date
   FROM ((public.bookings b
     JOIN public.users u ON ((b.user_id = u.id)))
     JOIN public.seats s ON ((b.seat_id = s.id)));
 "   DROP VIEW public.booking_history;
       public       v       postgres    false    224    224    224    224    224    224    222    222    218            �            1259    25526    bookings_id_seq    SEQUENCE     �   CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.bookings_id_seq;
       public               postgres    false    224            �           0    0    bookings_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;
          public               postgres    false    223            �            1259    25568    faq    TABLE     k   CREATE TABLE public.faq (
    id integer NOT NULL,
    question text NOT NULL,
    answer text NOT NULL
);
    DROP TABLE public.faq;
       public         heap r       postgres    false            �            1259    25567 
   faq_id_seq    SEQUENCE     �   CREATE SEQUENCE public.faq_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 !   DROP SEQUENCE public.faq_id_seq;
       public               postgres    false    227            �           0    0 
   faq_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE public.faq_id_seq OWNED BY public.faq.id;
          public               postgres    false    226            �            1259    25501    flights    TABLE     o  CREATE TABLE public.flights (
    id integer NOT NULL,
    flight_number character varying(20) NOT NULL,
    departure_airport character varying(100) NOT NULL,
    arrival_airport character varying(100) NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    aircraft_model character varying(100),
    status character varying(50) DEFAULT 'scheduled'::character varying,
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY ((ARRAY['scheduled'::character varying, 'delayed'::character varying, 'cancelled'::character varying])::text[])))
);
    DROP TABLE public.flights;
       public         heap r       postgres    false            �            1259    25500    flights_id_seq    SEQUENCE     �   CREATE SEQUENCE public.flights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.flights_id_seq;
       public               postgres    false    220            �           0    0    flights_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.flights_id_seq OWNED BY public.flights.id;
          public               postgres    false    219            �            1259    25553    loyalty_program    TABLE     �  CREATE TABLE public.loyalty_program (
    user_id integer NOT NULL,
    points integer DEFAULT 0,
    level character varying(20) DEFAULT 'basic'::character varying,
    discount_percent numeric(5,2) DEFAULT 0.0,
    CONSTRAINT loyalty_program_level_check CHECK (((level)::text = ANY ((ARRAY['basic'::character varying, 'silver'::character varying, 'gold'::character varying, 'platinum'::character varying])::text[])))
);
 #   DROP TABLE public.loyalty_program;
       public         heap r       postgres    false            �            1259    25586    payment_methods    TABLE     k   CREATE TABLE public.payment_methods (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);
 #   DROP TABLE public.payment_methods;
       public         heap r       postgres    false            �            1259    25585    payment_methods_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_methods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.payment_methods_id_seq;
       public               postgres    false    231            �           0    0    payment_methods_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.payment_methods_id_seq OWNED BY public.payment_methods.id;
          public               postgres    false    230            �            1259    25595    payments    TABLE     �  CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer,
    payment_method_id integer,
    amount numeric(10,2) NOT NULL,
    payment_time timestamp without time zone DEFAULT now(),
    status character varying(20) DEFAULT 'pending'::character varying,
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'completed'::character varying, 'failed'::character varying])::text[])))
);
    DROP TABLE public.payments;
       public         heap r       postgres    false            �            1259    25594    payments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.payments_id_seq;
       public               postgres    false    233            �           0    0    payments_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;
          public               postgres    false    232            �            1259    25511    seats_id_seq    SEQUENCE     �   CREATE SEQUENCE public.seats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.seats_id_seq;
       public               postgres    false    222            �           0    0    seats_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.seats_id_seq OWNED BY public.seats.id;
          public               postgres    false    221            �            1259    25614    user_profile    VIEW     �   CREATE VIEW public.user_profile AS
 SELECT id AS user_id,
    full_name,
    email,
    phone,
    created_at
   FROM public.users;
    DROP VIEW public.user_profile;
       public       v       postgres    false    218    218    218    218    218            �            1259    25488    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    218            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    217            �            1259    25577 	   visa_info    TABLE     |   CREATE TABLE public.visa_info (
    id integer NOT NULL,
    country character varying(100),
    required_documents text
);
    DROP TABLE public.visa_info;
       public         heap r       postgres    false            �            1259    25576    visa_info_id_seq    SEQUENCE     �   CREATE SEQUENCE public.visa_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.visa_info_id_seq;
       public               postgres    false    229            �           0    0    visa_info_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.visa_info_id_seq OWNED BY public.visa_info.id;
          public               postgres    false    228            �           2604    25647    bookings id    DEFAULT     j   ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);
 :   ALTER TABLE public.bookings ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    224    223    224            �           2604    25648    faq id    DEFAULT     `   ALTER TABLE ONLY public.faq ALTER COLUMN id SET DEFAULT nextval('public.faq_id_seq'::regclass);
 5   ALTER TABLE public.faq ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    226    227            �           2604    25649 
   flights id    DEFAULT     h   ALTER TABLE ONLY public.flights ALTER COLUMN id SET DEFAULT nextval('public.flights_id_seq'::regclass);
 9   ALTER TABLE public.flights ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    219    220    220            �           2604    25650    payment_methods id    DEFAULT     x   ALTER TABLE ONLY public.payment_methods ALTER COLUMN id SET DEFAULT nextval('public.payment_methods_id_seq'::regclass);
 A   ALTER TABLE public.payment_methods ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    231    230    231            �           2604    25651    payments id    DEFAULT     j   ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);
 :   ALTER TABLE public.payments ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    232    233    233            �           2604    25652    seats id    DEFAULT     d   ALTER TABLE ONLY public.seats ALTER COLUMN id SET DEFAULT nextval('public.seats_id_seq'::regclass);
 7   ALTER TABLE public.seats ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    221    222    222            �           2604    25653    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    218    217    218            �           2604    25654    visa_info id    DEFAULT     l   ALTER TABLE ONLY public.visa_info ALTER COLUMN id SET DEFAULT nextval('public.visa_info_id_seq'::regclass);
 ;   ALTER TABLE public.visa_info ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    229    229            �          0    25527    bookings 
   TABLE DATA           _   COPY public.bookings (id, user_id, flight_id, seat_id, booking_status, created_at) FROM stdin;
    public               postgres    false    224   �o       �          0    25568    faq 
   TABLE DATA           3   COPY public.faq (id, question, answer) FROM stdin;
    public               postgres    false    227   Jp       �          0    25501    flights 
   TABLE DATA           �   COPY public.flights (id, flight_number, departure_airport, arrival_airport, departure_time, arrival_time, aircraft_model, status) FROM stdin;
    public               postgres    false    220   r       �          0    25553    loyalty_program 
   TABLE DATA           S   COPY public.loyalty_program (user_id, points, level, discount_percent) FROM stdin;
    public               postgres    false    225   (s       �          0    25586    payment_methods 
   TABLE DATA           3   COPY public.payment_methods (id, name) FROM stdin;
    public               postgres    false    231   �s       �          0    25595    payments 
   TABLE DATA           c   COPY public.payments (id, booking_id, payment_method_id, amount, payment_time, status) FROM stdin;
    public               postgres    false    233   �s       �          0    25512    seats 
   TABLE DATA           O   COPY public.seats (id, flight_id, seat_number, is_reserved, price) FROM stdin;
    public               postgres    false    222   Nt       �          0    25489    users 
   TABLE DATA           r   COPY public.users (id, email, password_hash, full_name, phone, created_at, default_payment_method_id) FROM stdin;
    public               postgres    false    218   ;w       �          0    25577 	   visa_info 
   TABLE DATA           D   COPY public.visa_info (id, country, required_documents) FROM stdin;
    public               postgres    false    229   yx       �           0    0    bookings_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.bookings_id_seq', 39, true);
          public               postgres    false    223            �           0    0 
   faq_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.faq_id_seq', 10, true);
          public               postgres    false    226            �           0    0    flights_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.flights_id_seq', 5, true);
          public               postgres    false    219            �           0    0    payment_methods_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.payment_methods_id_seq', 5, true);
          public               postgres    false    230            �           0    0    payments_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.payments_id_seq', 25, true);
          public               postgres    false    232            �           0    0    seats_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.seats_id_seq', 15, true);
          public               postgres    false    221            �           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 6, true);
          public               postgres    false    217            �           0    0    visa_info_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.visa_info_id_seq', 5, true);
          public               postgres    false    228            �           2606    25537 '   bookings bookings_flight_id_seat_id_key 
   CONSTRAINT     p   ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_flight_id_seat_id_key UNIQUE (flight_id, seat_id);
 Q   ALTER TABLE ONLY public.bookings DROP CONSTRAINT bookings_flight_id_seat_id_key;
       public                 postgres    false    224    224            �           2606    25535    bookings bookings_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.bookings DROP CONSTRAINT bookings_pkey;
       public                 postgres    false    224            �           2606    25575    faq faq_pkey 
   CONSTRAINT     J   ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_pkey PRIMARY KEY (id);
 6   ALTER TABLE ONLY public.faq DROP CONSTRAINT faq_pkey;
       public                 postgres    false    227            �           2606    25510 !   flights flights_flight_number_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_flight_number_key UNIQUE (flight_number);
 K   ALTER TABLE ONLY public.flights DROP CONSTRAINT flights_flight_number_key;
       public                 postgres    false    220            �           2606    25508    flights flights_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.flights DROP CONSTRAINT flights_pkey;
       public                 postgres    false    220            �           2606    25561 $   loyalty_program loyalty_program_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT loyalty_program_pkey PRIMARY KEY (user_id);
 N   ALTER TABLE ONLY public.loyalty_program DROP CONSTRAINT loyalty_program_pkey;
       public                 postgres    false    225            �           2606    25593 (   payment_methods payment_methods_name_key 
   CONSTRAINT     c   ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_name_key UNIQUE (name);
 R   ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_name_key;
       public                 postgres    false    231            �           2606    25591 $   payment_methods payment_methods_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.payment_methods DROP CONSTRAINT payment_methods_pkey;
       public                 postgres    false    231            �           2606    25603    payments payments_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_pkey;
       public                 postgres    false    233            �           2606    25520 %   seats seats_flight_id_seat_number_key 
   CONSTRAINT     r   ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_flight_id_seat_number_key UNIQUE (flight_id, seat_number);
 O   ALTER TABLE ONLY public.seats DROP CONSTRAINT seats_flight_id_seat_number_key;
       public                 postgres    false    222    222            �           2606    25518    seats seats_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.seats DROP CONSTRAINT seats_pkey;
       public                 postgres    false    222            �           2606    25499    users users_email_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);
 ?   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_key;
       public                 postgres    false    218            �           2606    25497    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    218            �           2606    25584    visa_info visa_info_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.visa_info
    ADD CONSTRAINT visa_info_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.visa_info DROP CONSTRAINT visa_info_pkey;
       public                 postgres    false    229            �           2620    25625 $   flights trigger_flight_status_update    TRIGGER     �   CREATE TRIGGER trigger_flight_status_update AFTER UPDATE ON public.flights FOR EACH ROW WHEN (((old.status)::text IS DISTINCT FROM (new.status)::text)) EXECUTE FUNCTION public.notify_delay();
 =   DROP TRIGGER trigger_flight_status_update ON public.flights;
       public               postgres    false    220    238    220            �           2606    25543     bookings bookings_flight_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.bookings DROP CONSTRAINT bookings_flight_id_fkey;
       public               postgres    false    220    224    4823            �           2606    25548    bookings bookings_seat_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_seat_id_fkey FOREIGN KEY (seat_id) REFERENCES public.seats(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.bookings DROP CONSTRAINT bookings_seat_id_fkey;
       public               postgres    false    222    224    4827            �           2606    25538    bookings bookings_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.bookings DROP CONSTRAINT bookings_user_id_fkey;
       public               postgres    false    4819    218    224            �           2606    25562 ,   loyalty_program loyalty_program_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.loyalty_program
    ADD CONSTRAINT loyalty_program_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.loyalty_program DROP CONSTRAINT loyalty_program_user_id_fkey;
       public               postgres    false    225    218    4819            �           2606    25604 !   payments payments_booking_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_booking_id_fkey;
       public               postgres    false    4831    224    233            �           2606    25609 (   payments payments_payment_method_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_method_id_fkey FOREIGN KEY (payment_method_id) REFERENCES public.payment_methods(id);
 R   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_payment_method_id_fkey;
       public               postgres    false    4841    231    233            �           2606    25521    seats seats_flight_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.seats DROP CONSTRAINT seats_flight_id_fkey;
       public               postgres    false    4823    222    220            �           2606    25628 *   users users_default_payment_method_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_default_payment_method_id_fkey FOREIGN KEY (default_payment_method_id) REFERENCES public.payment_methods(id);
 T   ALTER TABLE ONLY public.users DROP CONSTRAINT users_default_payment_method_id_fkey;
       public               postgres    false    231    4841    218            �   _   x�m�=
�0��99����4�gq�R��p��ƇW$6eX֫�;��ׁ�2W��RP=;�{�Z?>2W���XQ˛��d@�SN�焈��?      �   �  x�}S�N�@>�O���4z��d<y��p0^H��J���1F|�[(�]^a�|��m	�H��;?�|��lO�N�֚�nD3�'�"k*(u�ED�r
���QzѠ)YxaWH��j�RZq��ɸ��b)=p�����҄�t+�@2_�+Z*]a��YQ�!!dI���kz�����#�*�u)�t[US&��FQ�����{���:���ɍmdv�����<`$�qg�Fh��  ����pq�	�²f>T����z����:7�վ�U�{[��j�;��}�MCu.�T���9�al{-&�s�gU-'d�q�(���xgWn|pL"FvTߍR��ǝM������י��䖾%P�1܇uc�]���e�\5G����É�ќ��e`���)w��d/�tع�? � ��'��G"Pu*�~�<�      �   
  x�]��j�0Eg�+�)O�U���ؽC�m�I�!C��S׶[)�LZCi�����d�t��
��3!����;�?;�&A���) ��%����zY��"�l[��rW�2�^��@���ۻgl� �L��Th�v���F��_y��'��;��v�)����Q\ȩ��:��V�r�噒�J[古��e@�_���?Q������9��8��nX�o
[���'�Ғ�u�������hf��~y�,�en/�(��1��      �   P   x�U�I� D�u�aH5�m��C���";�?�+�!�<���$J�g>��cM�n����+�
�t��^�m읈�7>      �   T   x�3�0�{/캰�¦��@z��~0�p���.#Nǂ��T���J.cN���t(ǄH$�p�r^�za���s��qqq t&�      �   R   x�U���0k{
�z;6�B�@P��H	�U�;s*AJ
�,Ftʠ��!��:�=mg*�2��)a�t��Wa�}�      �   �  x�U�Av� D��a�h���'����`���/�PZv=��0e������f%?JyXm(�(V�r�|�3��|f*^��OUE�����;�[�@Ѭ([n�%τ����R�P�S�@��H��*�漣ܜ���͹��䭄��9�quNGQ�0�9!��3��_��dղٵ<Ӧ�S�C��s	��Wጩ�4�"4M�4��kJG���%�!uIqH]R�S,��PS�BM5,= KI	�RR���`	SRҔ�,[����#�l����F�C��r	��Zo�Z�)$�[�� ;�fCp�hP�x6�\<X�<T.��PO�bq7(B-����b�C�b�C��r*{�*%c�*W�TjƱ�=â;��w���|f�㜍�>�
s��ٙ_��`^�G2�c��Y��s�ϗ�ϗ�ϗ�ϗ�ϗ�/��/���B���/��؇!�Ss%X1W��-P��T�ie�Ǵ2��1��zL�ɨ���dTO�z2��j�Q���E9�[֎r˂�oY0��da�[���Ua�[���Ua�J
+n�Ca�VO�RS��Qa��Ө���iTXj�5*,5�Qa�Y\�����޾ܜ���\��nO�֛�u�r�M��1sXO�眰/󉟿��l��t
��?��x:����|qs�r���e2�zm	"��[2�z�J���ܐS��YpEN�)X��;��7�D��_te�J7�1>�ֹH���x<�:��      �   .  x�}��J�0���S�.헤e;�A�d.�ҭ��+�SU�$�AA��A����_�ȴ����|�����G�\��Rgi�'3N�E2#�����
�~��ܚ�"g<�з{ �	� {���q����}_ģ@�TǊՎ$W��.Z����X9���Uc��.�t8�DM��ױ��6B�ⱽ�䩑��M�_���7s�_��1����|)8x]:���U*6�IZ'������)̓ytp�[\��XY	$ԕ	��T��N'�`��0��ScK��?m�o��w���Kz�(����,      �     x��Q1n�0��W���6�o�ۍ�	��C����M"D�c���wS��bH<���/H���3��^y<R����i��i	g�6Ș99�i�S��(8*X����J���L��<ㄉ�g�}��dM�#:���H���F�O�	�IQa�_'�hIN怪�hT2���%,b-�2��/>H��l�Z6��t�-�m�Q�����l�Q]�K�7��$�󇻟�oq̋j ]M-]>���4��s�Va7�x�0܈\��h���8�l�     