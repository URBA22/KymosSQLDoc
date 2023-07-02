class Version {
    public author: string;
    public version: string;
    public description: string;

    constructor(author: string, version: string, description: string) {
        this.author = author;
        this.description = description;
        this.version = version;
    }
}

enum Tokens {
    SUMMARY = '@summary',
    AUTHOR = '@author',
    CUSTOM = '@custom',
    STANDARD = '@standard',
    VERSION = '@version'
}

export class Info {
    public summary?: string;
    public author?: string;
    public custom?: string;
    public standard?: string;
    public versions?: Version[];

    public static async fromComments(comments: string) {
        const info: Info = {
            summary: (await Info.getDescriptionFromToken(comments, Tokens.SUMMARY))?.description,
            author: (await Info.getDescriptionFromToken(comments, Tokens.AUTHOR))?.description,
            custom: (await Info.getDescriptionFromToken(comments, Tokens.CUSTOM))?.description,
            standard: (await Info.getDescriptionFromToken(comments, Tokens.STANDARD))?.description,
            versions: await Info.getVersions(comments)
        };

        return info;
    }

    private static async getDescriptionFromToken(comments: string, token: string) {
        const lowerComments = comments.toLowerCase();
        if (!lowerComments.includes(token)) {
            return;
        }

        const start = lowerComments.indexOf(token) + token.length + 1;
        const end = lowerComments.indexOf('\n', start + 1);
        return {
            start,
            end,
            description: comments
                .substring(start, end)
                .trim()
        };
    }

    private static async getVersions(comments: string) {
        let start = 0;
        let description = '';

        const versions: Version[] = [];

        while (comments.toLowerCase().indexOf(Tokens.VERSION, start) >= 0) {
            const res = await this.getDescriptionFromToken(comments, Tokens.VERSION);

            start = res?.start ?? comments.length;
            description = res?.description ?? '';

            await Info.addVersion(description, versions);

            start++;
        }

        return versions;
    }

    private static async addVersion(description: string, versions: Version[]) {
        const version = await this.getVersion(description);
        if (version != undefined) {
            versions.push(version as Version);
        }
    }

    private static async getVersion(commentLine: string): Promise<Version | undefined> {
        const parts = commentLine.split(' ');

        if (parts.length < 3) return;

        return {
            author: parts[0],
            version: parts[1],
            description: parts.slice(2).join(' ')
        };
    }
}