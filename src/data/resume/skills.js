// TODO: Add Athletic Skills, Office Skills,
// Data Engineering, Data Science, ML Engineering, ... ?

const skills = [{
  title: 'Javascript',
  competency: 5,
  category: ['Web Development', 'Languages', 'Javascript'],
},
{
  title: 'Node',
  competency: 4,
  category: ['Web Development', 'Javascript'],
},
{
  title: 'React',
  competency: 3,
  category: ['Web Development', 'Javascript'],
},
{
  title: 'Bash',
  competency: 2,
  category: ['Tools', 'Languages'],
},
{
  title: 'Amazon Web Services',
  competency: 3,
  category: ['Web Development', 'Tools'],
},
{
  title: 'Google Cloud Platform',
  competency: 4,
  category: ['Web Development', 'Tools'],
},
{
  title: 'Heroku',
  competency: 2,
  category: ['Web Development', 'Tools', 'Javascript'],
},
{
  title: 'MongoDB',
  competency: 2,
  category: ['Web Development', 'Databases'],
},
{
  title: 'ElasticSearch',
  competency: 3,
  category: ['Web Development', 'Databases'],
},
{
  title: 'Terraform',
  competency: 4,
  category: ['Tools'],
},
{
  title: 'PostgreSQL/SQLite3/SQL',
  competency: 3,
  category: ['Web Development', 'Databases', 'Languages'],
},
{
  title: 'Redis',
  competency: 1,
  category: ['Web Development', 'Databases'],
},
{
  title: 'Data Mining',
  competency: 1,
  category: ['Data Science'],
},
{
  title: 'Express.JS',
  competency: 2,
  category: ['Web Development', 'Javascript'],
},
{
  title: 'Flask',
  competency: 2,
  category: ['Web Development', 'Python'],
},
{
  title: 'Azure DevOps',
  competency: 3,
  category: ['Tools'],
},
{
  title: 'GitLab',
  competency: 3,
  category: ['Tools'],
},
{
  title: 'Git',
  competency: 4,
  category: ['Tools'],
},
{
  title: 'Kafka',
  competency: 3,
  category: ['Tools', 'Databases'],
},
{
  title: 'Kubernetes',
  competency: 5,
  category: ['Tools', 'Data Engineering'],
},
{
  title: 'Jupyter',
  competency: 1,
  category: ['Data Science', 'Python'],
},
{
  title: 'Typescript',
  competency: 2,
  category: ['Web Development', 'Languages', 'Javascript'],
},
{
  title: 'HTML + SASS/SCSS/CSS',
  competency: 3,
  category: ['Web Development', 'Languages'],
},
{
  title: 'Python',
  competency: 3,
  category: ['Languages', 'Data Science', 'Python'],
},
{
  title: 'C++',
  competency: 3,
  category: ['Languages'],
},
{
  title: 'Hadoop',
  competency: 1,
  category: ['Data Engineering', 'Data Science'],
},
{
  title: 'Spark',
  competency: 1,
  category: ['Data Engineering', 'Data Science'],
},
{
  title: 'Dagster',
  competency: 1,
  category: ['Data Engineering', 'Python'],
},
{
  title: 'Pylint',
  competency: 2,
  category: ['Data Engineering', 'Python'],
},
{
  title: 'Puppet',
  competency: 2,
  category: ['Tools'],
},
{
  title: 'Hashicorp Vault',
  competency: 3,
  category: ['Tools'],
},
{
  title: 'Ansible',
  competency: 2,
  category: ['Tools'],
},
{
  title: 'Atlassian Tool Suite',
  competency: 5,
  category: ['Tools'],
},
{
  title: 'Prometheus/Grafana',
  competency: 4,
  category: ['Data Engineering', 'Tools'],
},
{
  title: 'Dynatrace',
  competency: 2,
  category: ['Data Engineering', 'Tools'],
},
{
  title: 'Datadog',
  competency: 2,
  category: ['Data Engineering', 'Tools'],
},
{
  title: 'Go',
  competency: 3,
  category: ['Languages'],
},
{
  title: 'C#',
  competency: 2,
  category: ['Languages'],
},
].map((skill) => ({ ...skill, category: skill.category.sort() }));

// this is a list of colors that I like. The length should be == to the
// number of categories. Re-arrange this list until you find a pattern you like.
const colors = [
  '#6968b3',
  '#37b1f5',
  '#40494e',
  '#515dd4',
  '#e47272',
  '#cc7b94',
  '#3896e2',
  '#c3423f',
  '#d75858',
  '#747fff',
  '#64cb7b',
];

const categories = [...new Set(
  skills.reduce((acc, { category }) => acc.concat(category), []),
)].sort().map((category, index) => ({
  name: category,
  color: colors[index],
}));

export { categories, skills };
