// Deletes the calling user's account.
//  1. Verifies the caller from their JWT (never trusts a user id sent in the body).
//  2. Anonymises their profile and removes personal rows (public.anonymize_user).
//  3. Removes their avatar files.
//  4. Soft-deletes the auth user so message history of other people stays intact.
// SUPABASE_URL / SUPABASE_ANON_KEY / SUPABASE_SERVICE_ROLE_KEY are injected by Supabase.
// The service-role key lives ONLY here, never in the app.
import { createClient } from "jsr:@supabase/supabase-js@2";

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  const authorization = req.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

  const url = Deno.env.get("SUPABASE_URL")!;
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY")!;
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

  const asCaller = createClient(url, anonKey, { global: { headers: { Authorization: authorization } } });
  const { data, error } = await asCaller.auth.getUser();
  if (error || !data.user) return json({ error: "unauthorized" }, 401);
  const userId = data.user.id;

  const admin = createClient(url, serviceKey, { auth: { persistSession: false } });

  const { error: anonymizeError } = await admin.rpc("anonymize_user", { p_user_id: userId });
  if (anonymizeError) return json({ error: "anonymize_failed" }, 500);

  // Best effort: a failure here must not leave the account half-deleted.
  const { data: files } = await admin.storage.from("avatars").list(userId);
  if (files && files.length > 0) {
    await admin.storage.from("avatars").remove(files.map((f) => `${userId}/${f.name}`));
  }

  const { error: deleteError } = await admin.auth.admin.deleteUser(userId, true);
  if (deleteError) return json({ error: "delete_failed" }, 500);

  return json({ ok: true });
});
