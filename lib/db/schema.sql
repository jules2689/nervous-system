CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "todoist_records" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" text, "external_id" varchar, "project_id" integer, "notion_id" varchar, "section_id" integer, "category" varchar, "status" varchar, "due_date" datetime, "raw_data" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX "index_todoist_records_on_external_id" ON "todoist_records" ("external_id");
CREATE TABLE IF NOT EXISTS "geekbot_records" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "geekbot_id" integer, "avatar" varchar, "name" varchar, "content" text, "date" varchar, "standup_id" integer, "notion_id" varchar, "raw_data" text);
INSERT INTO "schema_migrations" (version) VALUES
('20210515235431'),
('20210516205103');


