--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_uploads_on_delete(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_uploads_on_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE uploader
  SET uploads = uploads - 1
  WHERE uploader_id = OLD.uploader_id;
  RETURN OLD;
END;
$$;


ALTER FUNCTION public.update_uploads_on_delete() OWNER TO postgres;

--
-- Name: update_uploads_on_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_uploads_on_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE uploader
  SET uploads = uploads + 1
  WHERE uploader_id = NEW.uploader_id;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_uploads_on_insert() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    comment_id integer NOT NULL,
    comment character varying(255) NOT NULL,
    uploader_id integer NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_comment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_comment_id_seq OWNER TO postgres;

--
-- Name: comments_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_comment_id_seq OWNED BY public.comments.comment_id;


--
-- Name: content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.content (
    content_id integer NOT NULL,
    name character varying(255) NOT NULL,
    path_to_file character varying(255) NOT NULL,
    size integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    description character varying(255),
    type boolean NOT NULL,
    extension character varying(10) NOT NULL,
    length integer,
    sound boolean,
    upload_time timestamp without time zone NOT NULL,
    uploader_id integer NOT NULL
);


ALTER TABLE public.content OWNER TO postgres;

--
-- Name: content_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.content_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.content_content_id_seq OWNER TO postgres;

--
-- Name: content_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.content_content_id_seq OWNED BY public.content.content_id;


--
-- Name: post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post (
    post_id integer NOT NULL,
    content_id integer NOT NULL,
    likes integer NOT NULL,
    rating boolean NOT NULL
);


ALTER TABLE public.post OWNER TO postgres;

--
-- Name: post_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_comments (
    post_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.post_comments OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.post_post_id_seq OWNER TO postgres;

--
-- Name: post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_post_id_seq OWNED BY public.post.post_id;


--
-- Name: post_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_tags (
    post_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.post_tags OWNER TO postgres;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tags (
    tag_id integer NOT NULL,
    tag_type smallint NOT NULL,
    tag character varying(50) NOT NULL,
    description character varying(255),
    CONSTRAINT tags_tag_type_check CHECK (((tag_type >= 0) AND (tag_type <= 3)))
);


ALTER TABLE public.tags OWNER TO postgres;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tags_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tags_tag_id_seq OWNER TO postgres;

--
-- Name: tags_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tags_tag_id_seq OWNED BY public.tags.tag_id;


--
-- Name: uploader; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploader (
    uploader_id integer NOT NULL,
    name character varying(50) NOT NULL,
    reg_date timestamp without time zone NOT NULL,
    status boolean NOT NULL,
    is_admin boolean NOT NULL,
    description character varying(255),
    uploads integer NOT NULL,
    reputation integer NOT NULL
);


ALTER TABLE public.uploader OWNER TO postgres;

--
-- Name: uploader_uploader_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uploader_uploader_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.uploader_uploader_id_seq OWNER TO postgres;

--
-- Name: uploader_uploader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uploader_uploader_id_seq OWNED BY public.uploader.uploader_id;


--
-- Name: comments comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN comment_id SET DEFAULT nextval('public.comments_comment_id_seq'::regclass);


--
-- Name: content content_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content ALTER COLUMN content_id SET DEFAULT nextval('public.content_content_id_seq'::regclass);


--
-- Name: post post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post ALTER COLUMN post_id SET DEFAULT nextval('public.post_post_id_seq'::regclass);


--
-- Name: tags tag_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags ALTER COLUMN tag_id SET DEFAULT nextval('public.tags_tag_id_seq'::regclass);


--
-- Name: uploader uploader_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploader ALTER COLUMN uploader_id SET DEFAULT nextval('public.uploader_uploader_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (comment_id, comment, uploader_id) FROM stdin;
1	She's so cute!	1
2	Wonderful artwork!	2
3	Beautiful.	1
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.content (content_id, name, path_to_file, size, width, height, description, type, extension, length, sound, upload_time, uploader_id) FROM stdin;
1	AoiNadeshiko	C:\\Users\\Shine\\WebstormProjects\\booruCourseProject\\public\\posts\\AoiNadeshiko.jpg	6855	2480	3100	Art with Aoi Nadeshiko who is smiling.	f	jpg	\N	\N	2024-12-24 18:46:08.841691	1
2	NicoleAmilion	C:\\Users\\Shine\\WebstormProjects\\booruCourseProject\\public\\posts\\NicoleAmilion.jpg	12718	4716	7828	Art with Nicole and Amilion in the car.	f	jpg	\N	\N	2024-12-25 11:17:12.655908	2
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post (post_id, content_id, likes, rating) FROM stdin;
1	1	20	f
2	2	15	t
\.


--
-- Data for Name: post_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_comments (post_id, comment_id) FROM stdin;
1	1
1	2
2	3
\.


--
-- Data for Name: post_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_tags (post_id, tag_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	17
1	18
1	19
1	20
1	21
1	22
1	23
2	24
2	25
2	26
2	27
2	28
2	29
2	30
2	31
2	32
2	33
2	34
2	35
2	36
2	37
2	38
2	39
2	40
2	41
2	42
2	43
2	44
2	45
2	46
2	47
2	48
2	49
2	50
2	51
2	52
2	53
2	54
2	55
2	56
2	57
2	58
2	59
2	60
2	61
2	62
2	63
2	64
2	65
2	66
2	67
2	68
2	69
2	70
2	71
2	72
2	73
2	74
2	75
2	4
2	5
2	6
2	10
2	12
2	18
2	19
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tags (tag_id, tag_type, tag, description) FROM stdin;
1	0	nau umi	For content made by nau umi.
2	1	idolmaster	Idolmaster (アイドルマスター, stylized as iDOLM@STER ) is a 2005 video game series by Namco (later Bandai Namco). The game follows the career of a producer from the 765 Production studio handling ten young idols.
3	2	aoi nadeshiko	Nadeshiko Aoi (藍井撫子 Aoi Nadeshiko) is one of the rival idols from Gakuen iDOLM@STER. A first-year student at Gokugetsu Gakuen and a B-rank Idol in its upper echelons.
4	3	1girl	An image depicting one female character.\n\nDolls only count if they act on their own.\n\nDepictions of characters in paintings, etc don't count unless it plays a major role in the work.\n\nIf the presence of a character is only implicated, it doesn't count.
5	3	black jacket	A jacket that is colored black.
6	3	blush	1. A rosy color in the cheeks. Sometimes indicates sexual arousal.\n2. A sudden reddening of the face, as from embarrassment, guilt, shame or modesty.\n\nNot to be confused with body blush, which refers to body parts other than the face.
7	3	fang	A character with a single, white, prominent canine tooth.\n\nDistinct from fangs, which are multiple prominent canine teeth, such as vampire or animal fangs.\n\nDistinct from skin fang, a single fang colored the same as the skin around a character's mouth.
8	3	gokugetsu academy uniform	For characters who wear gokugetsu academy uniform.
9	3	grey background	Backgrounds with a solid or predominantly grey color. Can also apply to gradient background in conjunction with another background color.
10	3	jacket	A garment that is sleeved and hip- or waist-length. Jackets are made from thin material, therefore they are lighter. While some are for fashion, they can also serve as protective clothing when thicker material is used.
11	3	long hair	Hair longer than the shoulders, up to reaching the waist. Shoulder length hair should be tagged with medium hair instead.\n\nSome characters may have very long hair, which extends past the waist, or absurdly long hair, which is longer than they are tall.
12	3	looking at viewer	When a character is making direct eye contact with the viewer. (i.e. simply looking at the camera/through the fourth wall)\n\nDon't confuse with eye contact, which relates to characters making eye contact amongst themselves.
13	3	looking to the side	When a character's gaze is directed to something off to their side. Most commonly are eyes looking 90 degrees across the shoulder, but may also include up to 45 degrees facing in either direction.
14	3	pink eyes	A character with pink colored eyes.
15	3	pink hair	Hair that is colored pink, an intermediate color between red and white.
16	3	school uniform	A uniform commonly worn by students of various grades depending on the country; in Japan, they're mostly worn by middle school and high school students. The two most common designs are the serafuku and blazer.
17	3	skin fang	A skin-colored fang that is drawn as part of the outline of the mouth as opposed to being a separate, white protruding tooth.
18	3	smile	An expression showing pleasure, amusement, or happiness, usually with the corners of the mouth turned up.\n\nIf the mouth is wide open and the teeth are visible, it may be a grin.
19	3	solo	An image containing a single person. No one else should be visible in the image.
20	3	twintails	A hair style where the hair is tied into sections forming two ponytails.
21	3	two-tone background	When a background consists of only two colors. May or may not involve a gradient transition between them.
22	3	upper body	An image of the upper body of the character, approximately from the navel up. This may or may not include the head.\n\nBust is an aliased term for this tag, and is not to be confused with breasts.
23	3	white background	Backgrounds that are completely or predominantly white in color. Can also apply to gradient background in conjunction with another background color.
24	0	lillly	For content created by lillly.
25	1	zenless zone zero	An action role-playing video game developed by miHoYo. Released on July 4, 2024.  Set on a post-apocalyptic setting of New Eridu, the player takes the role of a "Proxy".
26	2	amillion	The Bangboo typically seen with Nicole Demara. Its body is green and its left eye is crossed out.
27	2	nicole demara	Playable character in Zenless Zone Zero belonging to the Cunning Hares faction.
28	3	bare shoulders	When shoulders are exposed, as part of clothing design, pulling/falling down, or other. Bare shoulders are especially prominent in clothes that are sleeveless, strapless, or have low and wide-cut necklines (ie. off-shoulder shirt).
29	3	black ribbon	A ribbon that's colored black.
30	3	black shorts	Any style of shorts that are colored black.
31	3	black thighhighs	Thighhighs or over-kneehighs that are black.
32	3	breasts	An image where the breasts are noticeable.  This tag should not be used for flat-chested characters.
33	3	car interior	A scene set inside a car. The camera may be inside the car, or looking into the car from a close distance away.  The car itself should not normally be tagged unless the exterior of a car can be seen.
34	3	cleavage	The depression or valley created between a woman's breasts via partial exposure of the chest.
35	3	clothing cutout	An intentional hole or opening in a piece of clothing designed to expose part of the body. For example, a cleavage cutout is a hole in the chest that exposes the breasts, while a navel cutout is a hole in the stomach that exposes the navel.
36	3	crop top	A top, usually a tank top or sleeveless shirt, that is cut short, designed to expose the wearer's midriff, or navel, sometimes even revealing underboob.
37	3	cropped jacket	A piece of clothing similar to a jacket, but shorter, reaching just below the breasts. Often called a "bolero". If it's above the breasts, see shrug (clothing).
38	3	cutoffs	Denim shorts with no hem, and possibly fraying, at the bottom. Could be made by cutting off the legs of a pair of jeans, though they may also just be shorts manufactured to look like it.
39	3	earrings	An ornament or type of jewelry worn on the earlobes or in another ear piercing.
40	3	fingernails	Tag used when fingernails are noticeable in the image, i.e. the fingers aren't simply stubs.
41	3	green eyes	A character with green colored eyes.
42	3	hair ornament	An accessory worn in the hair for decoration or ornamentation purposes.  Accessories used to tie or hold the hair together, such as bows or ribbons, are not considered to be hair ornaments. Hair ornaments are strictly decorative.
43	3	hair ribbon	A ribbon worn in the hair.
44	3	hairclip	A decorative clip or clasp generally used to hold hair in place or for fashion purposes. Also known as a barrette or a hair slide.
45	3	heart	The ♥ symbol. Used to signify romance or enjoyment, and is one of the four suits in playing cards. It is a common representation for love.  For the body part, see heart (organ).
46	3	heart collar	A collar with a heart-shaped ornament in front, often a heart-shaped lock.
47	3	heart earrings	Earrings that are shaped like hearts or have hearts attached to them.
48	3	heart necklace	A necklace with a heart-shaped jewel attached on the front.
49	3	jewelry	Any decorative adornments worn on a person made from various metals, gemstones, shells and beads. Its purpose is to enhance the wearer's appearance, although there are practical-usage pieces such as medic-alert bracelets and military dog tags.
50	3	large breasts	Breasts that are larger than medium breasts but smaller than huge breasts.  Around/more than the same volume as a sphere with the same diameter as the character's face, but smaller than their head.
51	3	midriff	A moderately-sized rectangular gap between clothing that exposes the character's stomach. The total amount of exposed skin should equal no more than half the stomach’s surface.
52	3	mole	A small dark blemish on the skin. Sometimes known as a beauty mark.  See mole (animal) for the animal.
53	3	mole on breast	A mole on a breast.
54	3	mole on thigh	A mole located on someone's thigh.
55	3	mole under eye	A mole located just below someone's eye, also known as a "tear mole". Fashionable in Japan, surpassing the Marilyn Monroe-style beauty mark popular in Western pop culture.
56	3	navel	The belly button is showing, usually goes with either nude, stomach or midriff. Contrast with covered navel.
57	3	necklace	A simple, circular chain worn loosely around the neck as jewelry.  Different from pendant, which has a jewel fastened to a chain as a centerpiece, or choker, which fits snugly around the neck.
58	3	open fly	When the fly (crotch) of a character's pants or shorts is unzipped or unbuttoned.
59	3	open mouth	The mouth being open. Only use when sufficiently open to (theoretically) see inside.  If the mouth is only slightly parted use parted lips.  The opposite of this is closed mouth.
60	3	ribbon	A ribbon is a thin band of flexible material, typically cloth but also plastic or sometimes metal, used primarily for binding and tying. Often seen used in elaborate clothing and hair, and generally longer than it is wide.
61	3	short shorts	Shorts with an inseam length of two inches or less, showing most of the legs.
62	3	shorts	An item of clothing worn on the lower body at the waist, but does not fully cover the legs.
63	3	shoulder cutout	A clothing cutout that exposes the shoulders. Tops and dresses featuring these are typically referred to as a "cold shoulder top" or "cold shoulder dress" respectively.
64	3	single thighhigh	A character wearing a thighhigh on only one leg.
65	3	sitting	The butt resting on a surface (often a chair, couch, or bench), possibly in addition to the legs or feet. For a position with the knees on the floor, use kneeling (except with seiza below).
66	3	steering wheel	A type of steering control in vehicles and vessels.  Use this tag for steering mechanisms that generally resemble a car's steering wheel.  For the spoked steering wheels that resemble those in ships, use ship's wheel instead.
67	3	stomach	An exposed frontal abdomen, specifically the area around the navel and above the groin. For images pertaining to the internal organ itself, use stomach (organ).
68	3	strapless	A shirt, dress, or other top that doesn't have any straps, neck, or sleeves. The shoulders, neck, and usually the arms are left bare.
69	3	thighhighs	Stockings or socks that cover the legs from foot to thigh. They are held up by elastic thighbands, or sometimes a garter belt.  Thighhighs differ from pantyhose in that pantyhose covers the legs from waist to toe.
70	3	thighs	Upper part of the legs. Images tagged "thighs" should be centered around them, or at least have thighs prominently displayed. Thighs covered by thighhighs, pantyhose or any skintight clothes still count.
71	3	torn clothes	Clothes that are in a torn state.
72	3	torn thighhighs	Thighhighs or over-kneehighs that are torn.
73	3	tube top	A strapless garment consisting of a continuous band of fabric across the torso, with the neckline stopping at the character's chest. Length ranges from covering the entire torso to just covering the breasts, or part of them.
74	3	very long hair	Hair longer than the waist, up to the feet.  Hair less than waist-length is long hair. Hair longer than the body is absurdly long hair.
75	3	white tube top	A tube top that is colored white.
\.


--
-- Data for Name: uploader; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uploader (uploader_id, name, reg_date, status, is_admin, description, uploads, reputation) FROM stdin;
1	Shine	2024-12-24 17:53:41.830414	t	t	Creator of this platform.	1	100
2	User123	2024-12-24 18:03:48.895	f	f	Newbie.	1	2
\.


--
-- Name: comments_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_comment_id_seq', 3, true);


--
-- Name: content_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.content_content_id_seq', 2, true);


--
-- Name: post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_post_id_seq', 2, true);


--
-- Name: tags_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tags_tag_id_seq', 75, true);


--
-- Name: uploader_uploader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uploader_uploader_id_seq', 2, true);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (comment_id);


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (content_id);


--
-- Name: post_comments post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_pkey PRIMARY KEY (post_id, comment_id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (post_id);


--
-- Name: post_tags post_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_pkey PRIMARY KEY (post_id, tag_id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags tags_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_tag_key UNIQUE (tag);


--
-- Name: uploader uploader_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploader
    ADD CONSTRAINT uploader_pkey PRIMARY KEY (uploader_id);


--
-- Name: content trg_update_uploads_delete; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_uploads_delete AFTER DELETE ON public.content FOR EACH ROW EXECUTE FUNCTION public.update_uploads_on_delete();


--
-- Name: content trg_update_uploads_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_uploads_insert AFTER INSERT ON public.content FOR EACH ROW EXECUTE FUNCTION public.update_uploads_on_insert();


--
-- Name: comments comments_uploader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_uploader_id_fkey FOREIGN KEY (uploader_id) REFERENCES public.uploader(uploader_id);


--
-- Name: content content_uploader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_uploader_id_fkey FOREIGN KEY (uploader_id) REFERENCES public.uploader(uploader_id);


--
-- Name: post_comments post_comments_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(comment_id);


--
-- Name: post_comments post_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_comments
    ADD CONSTRAINT post_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: post post_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.content(content_id);


--
-- Name: post_tags post_tags_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(post_id);


--
-- Name: post_tags post_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_tags
    ADD CONSTRAINT post_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(tag_id);


--
-- PostgreSQL database dump complete
--

