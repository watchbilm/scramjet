export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    if (!url.pathname.startsWith("/proxy/")) {
      return new Response("Scramjet backend running", { status: 200 });
    }

    const target = url.pathname.replace("/proxy/", "");

    if (!target.startsWith("http")) {
      return new Response("Invalid URL", { status: 400 });
    }

    const response = await fetch(target, {
      method: request.method,
      headers: request.headers,
      body: request.body
    });

    return new Response(response.body, response);
  }
};